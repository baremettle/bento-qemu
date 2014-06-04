module BentoQemu
  class CLI < Thor

    desc 'build', 'Run packer build'
    method_option :packer_options,
                  :desc => <<-EOS.gsub(/^ {20}/, '').gsub(/\n/, ' ')
                    string of options to pass to packer,
                    e.g. "-var 'key1=val1' -var 'key2=val2'"
                  EOS
    def build(template)
      args = {}
      args[:packer_options] = options[:packer_options]
      args[:cwd] = config['bento_dir']
      Packer.build(template, args)
    end

  end
end
