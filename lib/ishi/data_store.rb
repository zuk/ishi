require 'yaml'

module Ishi
  class DataStore
    def initialize(dir)
      @dir = dir
      @mutexes = {}
    end

    def init_class(klass)
      subdir = directory_for_class(klass)
      FileUtils.mkdir_p(subdir) unless File.exists?(subdir)
    end

    def new_id_for_class(klass)
      new_id = nil
      mutex_for_class(klass).synchronize do
        ids = Dir.glob(directory_for_class(klass)+"/*.yml").collect{|f| f =~ /(\d+)\.yml/; $~[1].to_i}
        new_id = ids.max
      end
      return (new_id || 0) + 1
    end

    def directory_for_class(klass)
      # borrowed from ActiveSupport::Inflector#underscore
      @dir + '/' + klass.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def mutex_for_class(klass)
      @mutexes[klass] ||= Mutex.new
    end

    def extract_id_from_object(object)
      if object.kind_of?(String) || object.kind_of?(Array)
        object.object_id
      elsif object.kind_of?(Hash)
        object[:id] || object['id'] || object.object_id
      else
        object.id
      end
    end

    def filename_for_object(object)
      id = extract_id_from_object(object)
      raise Error, "Cannot generate a filename for #{object} because this object does not have a valid id." unless id.kind_of?(Integer)
      filename_for_class_and_id(object.class, id)
    end

    def filename_for_class_and_id(klass, id)
      klass = klass.to_s
      directory_for_class(klass) + "/#{id}.yml"
    end

    def store_object(object)
      # TODO: check that it's really a directory and not something else
      init_class(object.class) unless File.exists?(directory_for_class(object.class))

      id = extract_id_from_object(object)

      object.id = new_id_for_class(object.class) unless id

#      object.instance_variables.each do |var|
#        name = var.gsub(/^@/, '')
#        value = object.instance_variable_get(var)
#        data[name] = value
#      end

      mutex_for_class(object.class).synchronize do
        File.open(filename_for_object(object), 'w') do |f|
          YAML.dump(object, f)
        end
      end

      object
    end

    def retrieve_object_by_class_and_id(klass, id)
      begin
        object = YAML.load_file(filename_for_class_and_id(klass, id))
      rescue Errno::ENOENT
        raise NoSuchObject, "There is no #{klass.inspect} with id #{id.inspect} in datastore #{self}!"
      end
      
      return object
    end

    class Error < StandardError
    end

    class NoSuchObject < Error
    end
  end
end
