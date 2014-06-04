require 'English'
require 'bento_qemu/version'
require 'bento_qemu/util'
require 'bento_qemu/packer_template'
require 'bento_qemu/packer'
require 'bento_qemu/libvirt_box'

require 'pathname'

module BentoQemu
  class << self
    def source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
