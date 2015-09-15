require 'rake'
require 'erb'

module Firebat
  module Rake

  end
end

def process_template(path, name, dir)
  template = File.open(path, 'r').read
  File.open("./#{dir}/#{name}.rb", 'w+') do |file|
    file << ERB.new(template).result(binding)
  end
end

def create_directories!
  begin
    Dir.mkdir('./services')
    Dir.mkdir('./flows')
    Dir.mkdir('./processes')
  rescue
  end
end

def create_service(name)
  process_template('templates/service.erb', name, 'services')
end

def create_flow(name)
  process_template('templates/flow.erb', name, 'flows')
end

def create_process(name)
  process_template('templates/process.erb', name, 'processes')
end

namespace :scaffold do
  desc 'Generate entire Flare project structure'
  task :project do
    create_directories!
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
