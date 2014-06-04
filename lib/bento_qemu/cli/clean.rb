module BentoQemu
  class CLI < Thor

    desc('clean cache|builds|artifacts|templates', 'Clean the house')
    method_option(:force, :desc => 'Do not ask, just do it')
    def clean(what)
      case what
      when 'cache'
        rm_rf?("#{config['packer_dir']}/packer_cache/*", options)
      when 'builds'
        rm_rf?("#{config['build_dir']}/**/*.box", options)
      when 'artifacts'
        %w(artifacts packer).each do |dir|
          pattern = "#{dir}/{packer,output}-*"
          FileUtils.rm_rf Dir.glob(pattern).select { |f| File.directory? f }
        end
      when 'templates'
        rm_rf?("#{config['packer_dir']}/*.json", options)
      end
    end
  end
end
