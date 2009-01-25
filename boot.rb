require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/dictionary.sqlite3")
DataObjects::Sqlite3.logger = DataObjects::Logger.new('dictionary.log', :debug) # :off, :fatal, :error, :warn, :info, :debug

Dir["#{Dir.pwd}/{translator,models}/**/*.rb"].each { |f| require f }

# DataMapper.auto_migrate!
DataMapper.auto_upgrade!
