module BentoQemu
  module Util

    def dir_empty?(directory)
      (Dir.entries(directory) - %w(. ..)).empty?
    end

    # Cross-platform way of finding an executable in the $PATH.
    # http://stackoverflow.com/a/5471032
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable? exe
        end
      end
      nil
    end

    def which!(cmd)
      exe = which(cmd)
      fail "Executable #{cmd} not found in PATH." unless exe
      exe
    end

  end
end
