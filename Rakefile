require "bundler/gem_tasks"
require "rake/testtask"
require "xxd"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :dump do
  fixture = File.binread(File.join(File.dirname(__FILE__), "test/random-data-from-urandom"))
  puts Xxd.dump(fixture)
end

task :default => :dump
