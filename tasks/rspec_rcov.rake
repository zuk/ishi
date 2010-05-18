begin
  require 'spec'
  require 'rcov'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'spec'
  require 'rcov'
end
begin
  require 'spec/rake/spectask'
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec gem:
    gem install rspec
EOS
  exit(0)
end

desc "Run the specs in spec/**/*_spec.rb with rcov"
Spec::Rake::SpecTask.new('spec:rcov') do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', "gems"]
end
