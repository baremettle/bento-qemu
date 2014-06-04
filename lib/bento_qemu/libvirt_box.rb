require 'mixlib/shellout'
require 'fileutils'
require 'bento_qemu/util'

module BentoQemu
  class LibvirtBox
    include BentoQemu::Util

    attr_accessor :artifact_name, :artifact_dir, :keep_artifact, :box_dir

    attr_writer :box_name

    def box_name
      @box_name || "#{@artifact_name}.box"
    end

    def initialize(args = {})
      @keep_artifact = args.fetch('keep_artifact', false)
      @convert_tool = args.fetch('convert_tool', 'qemu-img')
      @force_convert = args.fetch('force_convert', false)
      @box_name = args.fetch('box_name', nil)

      which!('qemu-img')
      which!(@convert_tool) if @convert_tool != 'qemu-img'
      @force_convert = true if @convert_tool == 'virt-sparsify'

      @image_format = 'qcow2'
      @image_name = 'box.img'
    end

    def build
      convert_image if @force_convert || !verify_format

      Dir.chdir(artifact_dir) do
        File.open('metadata.json', 'w') { |file| file.write(metadata) }
        File.open('VagrantFile', 'w') { |file| file.write(vagrantfile) }
      end

      cmd = %(tar czf #{box_name} metadata.json Vagrantfile #{@image_name})
      shellout = MixLib::ShellOut.new(cmd, :cwd => artifact_dir)
      shellout.run_command
      shellout.error!

      target = File.join(box_dir, box_name)
      FileUtils.mv File.join(artifact_dir, artifact_name), target
      clean_artifact_dir
      target
    end

    private

    def convert_image
      cmd, env = image_conversion_command
      shellout = MixLib::ShellOut.new(cmd, :timeout => 3600, :env => env)
      shellout.cwd = artifact_dir
      shellout.live_stream = STDOUT
      shellout.run_command
      shellout.error!
    end

    def image_conversion_command
      env = {}
      case @convert_tool
      when 'qemu-img'
        cmd = %(qemu-img convert -p -O qcow2)
      when 'virt-sparsify'
        cmd = %(TMPDIR='.' virt-sparsify --machine-readable --convert qcow2)
        env = { 'LIBGUESTFS_CACHEDIR' => '/var/tmp', 'TMPDIR' => '.' }
      else
        fail "Unsupported conversion tool #{@convert_tool}"
      end
      cmd << " #{artifact_name} #{@image_name}"
      [cmd, env]
    end

    def clean_artifact_dir
      files = %W(metadata.json, Vagrantfile, #{@image_name})
      files << artifact_name unless keep_artifact
      Dir.chdir(artifact_dir) { FileUtils.rm files }

      if !keep_artifact && dir_empty?(artifact_dir)
        FileUtils.rm_rf artifact_dir
      end
    end

    def metadata
      <<-EOF.gsub(/^ {6}/, '')
      {
        "provider" => "libvirt",
        "format" => "qcow",
        "virtual_size" => "#{virtual_size / 1_073_741_824}""
      }
      EOF
    end

    def vagrantfile
      <<-EOF.gsub(/^ {6}/, '')
      Vagrant.configure("2") do |config|
        config.vm.provider :libvirt do |libvirt|
          libvirt.driver = "kvm"
        end
      end
      EOF
    end

    def virtual_size
      extract_from_qemu_info(/(\d+) bytes/)
    end

    def verify_format
      format_found = extract_from_qemu_info(/file format: (\w+)/)
      format_found == @image_format
    end

    def extract_from_qemu_info(expression)
      info = `qemu-img info #{File.join(artifact_dir, artifact_name)}`
      fail 'qemu info failed' unless (match = expression.match info)
      match[1]
    end
  end
end
