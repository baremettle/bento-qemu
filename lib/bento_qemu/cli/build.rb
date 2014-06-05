module BentoQemu
  class CLI < Thor

    desc 'build TEMPLATE', 'Run packer build'
    method_option :build_only,
                  :type => :array,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    only build the given builds by name
                    e.g. --build-only qemu
                  EOS
    method_option :packer_options,
                  :banner => 'STRING',
                  :desc => <<-EOS.gsub(/^ {20}/, '')
                    additional packer options, e.g. "-var 'key1=val1'"
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
      args[:build_only] = options[:build_only]
      args[:cwd] = File.dirname(File.absolute_path(template))
      args[:input] = minimize_stripped(template) if options[:skip_minimize]
      Packer.build(filename, args)
    end

    desc 'build-and-box TEMPLATE', 'Run packer build and libvirt-box'
    method_option :build_only,
                  :type => :array,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    only build the given builds by name
                    e.g. --build-only qemu
                  EOS
    method_option :packer_options,
                  :banner => 'STRING',
                  :desc => <<-EOS.gsub(/^ {20}/, '')
                    additional packer options, e.g. "-var 'key1=val1'"
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
    def build_and_box(template)

      invoke('build',
             [template],
             :packer_options => options[:packer_options],
             :build_only => options[:build_only],
             :skip_minimize => options[:skip_minimize])

      invoke('libvirt_box',
             [template],
             :keep_artifact => options[:keep_artifact],
             :convert_tool => options[:convert_tool],
             :box_name => options[:box_name],
             :box_dir => options[:box_dir],
             :force => options[:force])
    end

    private

    def minimize_stripped(filename)
      template = PackerTemplate.new(:filename => filename)
      template.strip_minimize
      template.to_json
    end

  end
end
