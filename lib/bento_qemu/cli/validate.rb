module BentoQemu
  class CLI < Thor

    desc('validate', 'Validate packer templates in bento_dir')
    option :dir, :desc => 'Directory to validate instead of bento_dir'
    def validate
      fail_count = 0
      dir = options[:dir] || config['bento_dir']
      Dir.chdir dir do
        templates = Dir.glob('*.json').sort
        templates.each do |template|
          result = `packer validate #{template}`
          color = $CHILD_STATUS.success? ? :green : :red
          fail_count += 1 unless $CHILD_STATUS.success?
          say template, color
          say result, color
          say
        end

        if fail_count > 0
          say "Validation failed on #{fail_count} templates"
          exit(1)
        end
      end
    end
  end
end
