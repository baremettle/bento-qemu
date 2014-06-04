require 'mixlib/shellout'

module BentoQemu
  module Packer
    class << self

      def build(template, args = {})
        packer_options = args.fetch(:packer_options, [])
        shell_cwd = args.fetch(:cwd, Dir.pwd)
        cmd = [%(packer build)]
        cmd << packer_options
        cmd << template unless args[:input]
        shellout = Mixlib::ShellOut.new(cmd.join(' '), :timeout => 3600)
        shellout.cwd = shell_cwd
        shellout.live_stream = STDOUT
        shellout.run_command
        shellout.error!
      end
    end

  end
end
