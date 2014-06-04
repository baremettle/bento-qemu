require 'json'

module BentoQemu
  class PackerTemplate

    attr_accessor :template
    attr_reader :filename

    def initialize(options = {})
      @template = {}
      from_file(options[:filename]) if options[:filename]
    end

    def from_file(fname)
      @template = read_json_file(fname)
      @filename = fname
    end

    def to_file(fname = nil)
      fname ||= @filename
      File.open(fname, 'w') { |f| f.write(to_pretty_json) }
    end

    def to_pretty_json
      JSON.pretty_generate(@template)
    end

    def builders
      @template['builders']
    end

    def post_processors
      @template['post-processors']
    end

    def select_builder(criteria = {})
      builders.select do |builder|
        criteria.all? { |k, v| builder[k] == v }
      end
    end

    def select_post_processor(criteria = {})
      post_processors.select do |pp|
        criteria.all? { |k, v| pp[k] == v }
      end
    end

    def add_qemu_builder # rubocop: disable CyclomaticComplexity
      return nil if select_builder('type' => 'qemu').count > 0
      vbox_find = builders.find { |b| b['type'] == 'virtualbox-iso' }
      return nil unless vbox_find.nil? || vbox_find.empty?

      # Stupid hack to deep copy
      vbox = Marshal.load(Marshal.dump(vbox_find))

      path = File.join(BentoQemu.source_root, 'templates', 'qemu_builder.json')
      qemu = read_json_file(path)
      qemu.each { |k, v| qemu[k] = vbox[k] if v.nil? && vbox[k] }
      qemu.delete_if { |_, v| v.nil? }
      qemu.each do |_, val|
        val.gsub!(/virtualbox/, 'qemu') if val.is_a?(String)
      end
      builders.unshift(qemu)

      # add an except for any/all post-processors
      add_post_proc_except('qemu')
      true
    end

    def add_post_proc_except(name, criteria = {})
      if criteria.empty?
        post_procs = post_processors
      else
        post_procs = select_post_processor(criteria)
      end
      post_procs.each do |pp|
        next if pp.keys.include? 'only'
        if pp.keys.include? 'except'
          pp['except'] << name unless pp['except'].include? name
        else
          pp['except'] = [name]
        end
      end
    end

    def strip_minimize(template_hash = nil)
      templ = template_hash || @template
      if templ.key?('provisioners')
        templ['provisioners'].each do |p|
          if p['scripts']
            p['scripts'].delete_if { |s| s.end_with?('minimize.sh') }
          end
        end
      end
      templ
    end

    private

    def read_json_file(fname)
      JSON.parse(File.read(fname))
    end

  end
end
