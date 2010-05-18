begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

SANDBOX = File.dirname(__FILE__) + '/sandbox'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'ishi'
require 'ishi/persist'

def prep_sandbox
  FileUtils.remove_entry_secure SANDBOX if File.exists?(SANDBOX)
  FileUtils.mkdir_p SANDBOX
  Ishi.init(SANDBOX)
end