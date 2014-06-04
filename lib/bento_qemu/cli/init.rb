module BentoQemu
  class CLI < Thor

    desc('init', 'Create .bento_qemu.yml configuration file')
    method_option(:bento_repo_owner,
                  :default => 'opscode',
                  :desc => 'github user owning bento repository')
    method_option(:bento_repo_name,
                  :default => 'bento',
                  :desc => 'github bento repository name')
    method_option(:bento_ref,
                  :default => 'master',
                  :desc => 'branch/tag/ref to download from bento')
    method_option(:artifact_dir,
                  :default => '../artifacts',
                  :desc => 'directory to store packer artifacts' \
                    ' (relative to template file!!)')
    method_option(:build_dir,
                  :default => './builds',
                  :desc => 'where to store builds from box conversions')
    method_option(:bento_dir,
                  :default => './bento',
                  :desc => 'directory name of downloaded bento repository')
    method_option(:packer_dir,
                  :default => './packer_qemu',
                  :desc => 'directory to store converted templates')
    def init
      require 'yaml'
      File.open('.bento_qemu.yml', 'w') { |f| f.write options.to_hash.to_yaml }
    end

  end
end
