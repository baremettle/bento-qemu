require 'mixlib/shellout'

module BentoQemu
  module Packer
    class << self

      def build(template, args = {})
        packer_options = args[:packer_options] || []
        build_only = Array(args[:build_only]) || nil
        puts build_only.inspect
        shell_cwd = args.fetch(:cwd, Dir.pwd)
        std_in = args.fetch(:input, nil)

        cmd = [%(packer build)]
        cmd << packer_options
        cmd << ('-only ' + build_only.join(',')) if build_only
        cmd << (std_in.nil? ? template : '-')

        shellout = Mixlib::ShellOut.new(cmd.compact.join(' '))
        shellout.timeout = 3600
        shellout.cwd = shell_cwd
        shellout.input = std_in
        shellout.live_stream = STDOUT
        shellout.run_command
        shellout.error!
      end

    end
  end
end
