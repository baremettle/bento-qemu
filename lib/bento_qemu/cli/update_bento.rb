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
      %w(packer README.md LICENSE).each do |f|
        next unless File.exist?("#{unzip_dir}/#{f}")
        FileUtils.mv("#{unzip_dir}/#{f}", bento_dir)
      end
      FileUtils.rm_rf unzip_dir
      FileUtils.rm_rf "#{bento_dir}.tmp" if File.directory?("#{bento_dir}.tmp")

      add_qemu_builders
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
