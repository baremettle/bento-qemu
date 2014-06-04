module BentoQemu
  class CLI < Thor

    desc('libvirt-box TEMPLATE_FILE',
         'Convert qemu artifact to vagrant-libvirt compatible box')
    method_option(:keep_artifact,
                  :type => :boolean,
                  :default => false,
                  :desc => 'Keep artifact after converstion')
    method_option(:convert_tool,
                  :default => 'qemu-img',
                  :enum => %w(qemu-img virt-sparsify),
                  :default => 'qemu-img',
                  :desc => 'Tool used to convert images')
    method_option(:force_convert,
                  :type => :boolean,
                  :default => false,
                  :desc => 'Force image conversion/compression')
    method_option(:box_name,
                  :desc => 'Box name (Default: ARTIFACT_NAME.box')
    def libvirt_box(template_file)
      template = BentoQemu::PackerTemplate.new(:filename => template_file)
      builder = template.select_builder('type' => 'qemu')
      fail "Expected 1 builder, got #{builder.count}" unless builder.count == 1
      builder = builder.first

      artifact_dir = builder['output_directory']
      unless Pathname.new(artifact_dir).absolute?
        template_dir = File.expand_path(File.dirname(template_file))
        artifact_dir = File.join(template_dir, artifact_dir)
      end

      box = LibvirtBox.new(options)
      box.artifact_dir = artifact_dir
      box.artifact_name = "#{builder['vm_name']}.#{builder['format']}"
      box.box_dir = config['build_dir']
      say box.build
    end

  end
end
