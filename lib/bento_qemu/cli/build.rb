module BentoQemu
  class CLI < Thor

    desc 'build', 'Run packer build'
    method_option :packer_options,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    string of options to pass to packer,
                    e.g. "-var 'key1=val1' -var 'key2=val2'"
                  EOS
    method_option :skip_minimize,
                  :type => :boolean,
                  :default => false,
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

    private

    def minimize_stripped(filename)
      template = PackerTemplate.new(:filename => filename)
      template.strip_minimize
      template.to_json
    end

  end
end
