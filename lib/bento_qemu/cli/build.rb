module BentoQemu
  class CLI < Thor

    desc 'build TEMPLATE', 'Run packer build'
    method_option :packer_options,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    string of options to pass to packer,
                    e.g. "-var 'key1=val1' -var 'key2=val2'"
                  EOS
    method_option :skip_minimize,
                  :type => :boolean,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    attempt to remove 'minimize.sh' script from template
                    before building
                  EOS
    def build(template)
      filename = File.basename(template)
      args = {}
      args[:packer_options] = options[:packer_options]
      args[:cwd] = File.dirname(File.absolute_path(template))
      args[:input] = minimize_stripped(template) if options[:skip_minimize]
      Packer.build(filename, args)
    end

    desc 'build-and-box TEMPLATE', 'Run packer build and libvirt-box'
    method_option :packer_options,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    string of options to pass to packer,
                    e.g. "-var 'key1=val1' -var 'key2=val2'"
                  EOS
    method_option :skip_minimize,
                  :type => :boolean,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    attempt to remove 'minimize.sh' script from template
                    before building
                  EOS
    method_option :keep_artifact,
                  :type => :boolean,
                  :desc => 'Keep artifact after converstion'
    method_option :convert_tool,
                  :default => 'qemu-img',
                  :enum => %w(qemu-img virt-sparsify),
                  :default => 'qemu-img',
                  :desc => 'Tool used to convert images'
    method_option :box_name,
                  :desc => 'Box name (Default: ARTIFACT_NAME.box'
    method_option :box_dir,
                  :desc => 'Override build_dir from config'
    method_option :force,
                  :type => :boolean,
                  :desc => 'Force overwrite box if exists'
    def build_and_box(_template)
      invoke('build')
      invoke('libvirt-box')
    end

    private

    def minimize_stripped(filename)
      template = PackerTemplate.new(:filename => filename)
      template.strip_minimize
      template.to_json
    end

  end
end
