module BentoQemu
  class CLI < Thor

    desc('invoke-from-yaml FILENAME', 'Run tasks from YAML file')
    def invoke_from_yaml(filename)
      run_data = load_yaml(filename)
      unless run_data.key?('tasks')
        say "No tasks block found in #{filename}"
        exit(1)
      end
      @run_list = []
      normalize_run_list(run_data['tasks'])

      @run_list.each do |task|
        say "invoking task '#{task[:task]}' with args:#{task[:args]}"
        invoke_me task[:task], task[:args], task[:options]
      end
    end

    private

    def normalize_run_list(tasks)
      tasks.each do |t|
        exit(1) unless (task = task_name t['name'])
        exit(1) unless (args = validate_args(task, t.fetch('arguments', [])))
        options = t.fetch('options', {})
        @run_list << { :task => task, :args => args, :options => options }
      end
    end

    def load_yaml(filename)
      fail "YAML file #{filename} not found" unless File.exist?(filename)
      YAML.load_file(filename)
    end

    def task_name(name)
      task = name.gsub(/-/, '_')
      return task if respond_to? task
      say "Task name '#{name}' not valid", :red
      nil
    end

    def invoke_me(task, args = [], options = {})
      task = 'bento-qemu:' << task
      # Invoke using new instance to support calling same task multiple times
      CLI.new.invoke task, args, options
    end

    def req_args(task)
      arity = method(task).arity
      if arity >= 0
        min, max = arity, arity
      else
        min = (arity + 1).abs
        max = arity.abs
      end
      [min, max]
    end

    def validate_args(task, args)
      min, _max = req_args(task)
      return args if args.count == min
      say "Task #{task} expected minimum #{min} args,"\
        "#{args.count} provided", :red
      nil
    end

  end
end
