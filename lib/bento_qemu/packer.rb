require 'mixlib/shellout'

module BentoQemu
  module Packer
    class << self

      def build(template, args = {})
        packer_options = args[:packer_options] || []
        shell_cwd = args.fetch(:cwd, Dir.pwd)
        std_in = args.fetch(:input, nil)
        cmd = [%(packer build)]
        cmd << packer_options
        if std_in
          cmd << '-'
        else
          cmd << template
        end
        shellout = Mixlib::ShellOut.new(cmd.join(' '), :timeout => 3600)
        shellout.cwd = shell_cwd
        shellout.input = std_in
        shellout.live_stream = STDOUT
        shellout.run_command
        shellout.error!
      end
    end

  end
end
