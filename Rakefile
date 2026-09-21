# frozen_string_literal: true

require "rake/testtask"
require "bundler/gem_tasks"

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/*_test.rb"
end

desc "Run the small terminal benchmark"
task :bench do
  ruby "bench/terminal.rb"
end

task default: :test
