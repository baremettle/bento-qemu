module BentoQemu
  class CLI < Thor

    desc 'build', 'Run packer build'
    method_option :packer_options,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    string of options to pass to packer,
                    e.g. "-var 'key1=val1' -var 'key2=val2'"
                  EOS
    method_option :skip_minimize,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    attempt to remove 'minimize.sh' script from template
                    before building
                  EOS
    def build(template)
      dir = File.dirname(File.absolute_path(template))
      filename = File.basename(template)
      args = {}
      args[:packer_options] = options[:packer_options]
      args[:cwd] = File.dirname(File.absolute_path(template))
      args[:input] = template_minimize_stripped if options[:skip_minimize]
      Packer.build(filename, args)
    end

    private

    def template_minimize_stripped
      template = PackerTemplate.new(:filename => template)
      template.strip_minimize
    end

  end
end
