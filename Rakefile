require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'

require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :appraisal do
  desc "Run the given task for a particular integration's appraisals"
  task :integration do
    Appraisal::File.each do |appraisal|
      if RUBY_VERSION < '1.9.3' and appraisal.name  == 'actionpack4.0'
        # skip rails 4 for ruby < 1.9.3
      else
        appraisal.install
        Appraisal::Command.from_args(appraisal.gemfile_path).run
      end
    end
  end
end
