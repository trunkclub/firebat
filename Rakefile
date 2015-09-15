require 'rake'
require 'erb'

def process_template(path, name)
  template = File.open(path, 'r').read
  puts ERB.new(template).result(binding)
end

def create_service(name)
  process_template('templates/service.erb', name)
end

def create_flow(name)
  process_template('templates/flow.erb', name)
end

def create_process(name)
  process_template('templates/process.erb', name)
end

namespace :scaffold do
  desc 'Generate entire Flare project structure'
  task :project do
    create_service('MyService')
    create_flow('MyFlow')
    create_process('MyProcess')
  end

  [:service, :flow, :process].each do |name|
    klass_name = name.to_s.capitalize
    desc "Generate a new Firebat::#{klass_name} implementation"
    task name, [:name] do |_, args|
      create_service(args.to_h.fetch(:name, klass_name))
    end
  end
end
