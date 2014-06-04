module BentoQemu
  class CLI < Thor

    desc('update-bento', 'Download bento repository')
    def update_bento
      # TODO: Needs serious cleanup (move logic out of this class)
      owner, repo = config['bento_repo_owner'], config['bento_repo_name']
      bento_dir = config['bento_dir']
      host, ref = 'https://github.com', config['bento_ref']
      url = %(#{host}/#{owner}/#{repo}/archive/#{ref}.zip)

      FileUtils.mv(bento_dir, "#{bento_dir}.tmp") if File.directory?(bento_dir)
      `wget -q -O temp #{url} && unzip -q temp && rm temp`
      fail 'Command failed' unless $CHILD_STATUS.success?

      unzip_dir = "#{repo}-#{ref}"
      FileUtils.mv("#{unzip_dir}/packer", bento_dir)
      FileUtils.rm_rf unzip_dir
      FileUtils.rm_rf "#{bento_dir}.tmp" if File.directory?("#{bento_dir}.tmp")

      add_qemu_builders
      # packer_dir = config['packer_dir']
      # dirs = Dir.glob("#{bento_dir}/*").select { |f| File.directory? f }
      # FileUtils.mkdir_p(packer_dir) unless File.directory?(packer_dir)
      # dirs.each do |dir|
      #   link_name = File.join(packer_dir, File.basename(dir))
      #   FileUtils.ln_sf(File.expand_path(dir), link_name)
      # end
    end

    private

    def add_qemu_builders
      bento_files.each do |file|
        template = PackerTemplate.new(:filename => file)
        result = template.add_qemu_builder
        if result == true
          template.to_file
          say "Bento template #{file} successfully updated", :green
        else
          say "Unable to add Qemu builder for #{file}", :red
        end
      end
    end

    def bento_files
      Dir.glob("#{config['bento_dir']}/*.json")
    end

  end
end
