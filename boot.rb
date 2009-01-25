require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/dictionary.sqlite3")
DataObjects::Sqlite3.logger = DataObjects::Logger.new('dictionaly.log', :debug) # :off, :fatal, :error, :warn, :info, :debug

Dir["#{File.dirname(__FILE__)}/{translator,models}/**/*.rb"].each { |f| require f }

# DataMapper.auto_migrate!
DataMapper.auto_upgrade!
