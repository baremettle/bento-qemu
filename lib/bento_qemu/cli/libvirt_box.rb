module BentoQemu
  class CLI < Thor

    desc('libvirt-box TEMPLATE_FILE',
         'Convert qemu artifact to vagrant-libvirt compatible box')
    method_option(:keep_artifact,
                  :type => :boolean,
                  :default => false,
                  :desc => 'Keep artifact after converstion')
    method_option(:convert_tool,
                  :default => 'qemu-img',
                  :enum => %w(qemu-img virt-sparsify),
                  :default => 'qemu-img',
                  :desc => 'Tool used to convert images')
    method_option(:force_convert,
                  :type => :boolean,
                  :default => false,
                  :desc => 'Force image conversion/compression')
    method_option(:box_name,
                  :desc => 'Box name (Default: ARTIFACT_NAME.box')
    method_option(:box_dir,
                  :desc => 'Override build_dir from config')
    method_option(:force,
                  :type => :boolean,
                  :desc => 'Force overwrite box if exists')
    def libvirt_box(template_file)
      template = BentoQemu::PackerTemplate.new(:filename => template_file)
      @builder = template.select_builder('type' => 'qemu')
      unless @builder.count == 1
        fail "Expected 1 builder, got #{@builder.count}"
      end
      @builder = @builder.first

      return unless overwrite_box?

      artifact_dir = @builder['output_directory']
      unless Pathname.new(artifact_dir).absolute?
        template_dir = File.expand_path(File.dirname(template_file))
        artifact_dir = File.join(template_dir, artifact_dir)
      end

      box = LibvirtBox.new(options)
      box.artifact_dir = artifact_dir
      box.artifact_name = artifact
      box.box_dir = box_directory
      say box.build
    end

    private

    def artifact
      "#{@builder['vm_name']}.#{@builder['format']}"
    end

    def box_name
      options.fetch('box_name',
                    "#{File.basename(artifact, File.extname(artifact))}.box")
    end

    def box_directory
      options.fetch('box_dir', config['build_dir'])
    end

    def box_exist?
      File.exist?(File.join(box_directory, box_name))
    end

    def overwrite_box?
      return true unless box_exist?
      q = "OK to overrwite #{File.join(box_directory, box_name)}? (y/N)"
      options[:force] || yes?(q)
    end
  end
end
