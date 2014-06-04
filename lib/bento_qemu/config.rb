module BentoQemu
  class Config

    def initialize
      @config = {}
    end

    def config_file
      File.join(Dir.pwd, '.bento_qemu.yml')
    end

    # TODO: This is not safe, nor does it validate (but it works)
    def load
      unless File.exist?(config_file)
        fail "YAML file #{config_file} does not exist. Try 'bento-qemu init'."
      end
      @config = YAML.load_file(config_file)
    end
  end
end
