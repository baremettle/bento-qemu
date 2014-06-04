require 'thor'
require 'bento_qemu'
require 'yaml'

# CLI tasks
Dir[File.dirname(__FILE__) + '/cli/*.rb'].each { |file| require file }

module BentoQemu
  class CLI < Thor
    namespace 'bento_qemu'
    include BentoQemu::Util

    no_tasks do
      def config
        load_config if @config.empty?
        @config
      end
    end

    def initialize(*args)
      super
      @config = {}
      # $stdout.sync = true
    end

    private

    def config_file
      File.join(Dir.pwd, '.bento_qemu.yml')
    end

    # TODO: This is not really safe, nor does it validate (but it works)
    def load_config
      unless File.exist?(config_file)
        fail "YAML file #{config_file} does not exist. Try 'bento_qemu init'."
      end
      @config = YAML.load_file(config_file)
    end

  end
end
