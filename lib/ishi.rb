$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'fileutils'
require 'ishi/data_store'

module Ishi
  VERSION = '0.0.1'

  class << self
    def init(datastore_dir = nil)
      if datastore_dir
        raise "Cannot initialize Ishi with the datastore in #{datastore_dir.inspect} because this directory does not exist. " +
          "Please create the directory before trying to initialize Ishi again." unless
          File.exists?(datastore_dir)
      elsif const_defined?('RAILS_ROOT')
        datastore_dir = RAILS_ROOT + "/ishi"
        FileUtils.mkdir_p(datastore_dir) unless File.exists?(datastore_dir)
      else
        raise "Please specify a datastore location for Ishi.init. This should be the directory where Ishi is to store persisted data."
      end

      @datastore = DataStore.new(datastore_dir)
    end

    def datastore
      raise "No datastore defined for Ishi! Make sure you run Ishi.init first." unless @datastore
      @datastore
    end
  end
end