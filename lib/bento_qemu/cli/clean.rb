module BentoQemu
  class CLI < Thor

    desc('clean cache|builds|artifacts', 'Clean the house')
    method_option(:force, :desc => 'Do not ask, just do it')
    def clean(what)
      case what
      when 'cache'
        rm_rf?(Dir.glob("#{config['bento_dir']}/packer_cache/*"), options)
      when 'builds'
        rm_rf?(Dir.glob("#{config['build_dir']}/**/*.box"), options)
      when 'artifacts'
        files = Dir.glob("#{bento_dir}/{packer,output}-*")
        rm_rf?(files.select { |f| File.directory? f })
      end
    end

    private

    def rm_rf?(list, options)
      question = "OK to delete #{files.count} files/directories? (y/N)"
      if files.count > 0 && (options[:force] || yes?(question))
        FileUtils.rm_rf(files)
      elsif files.count == 0
        say "No files found in #{pattern}"
      end
    end

  end
end
