require "rspec/core/rake_task"

task :default => [:spec, :build]

RSpec::Core::RakeTask.new(:spec)

task :build do
  system "gem build omniauth-owa.gemspec"
end
