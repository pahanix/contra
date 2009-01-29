require 'rubygems'
# require 'extlib' # included in dm-core''
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/dictionary.sqlite3")
DataObjects::Sqlite3.logger = DataObjects::Logger.new('log/dictionary.log', :debug) # :off, :fatal, :error, :warn, :info, :debug

Dir["#{Dir.pwd}/{translator,models}/**/*.rb"].each { |f| require f }

# DataMapper.auto_migrate!
DataMapper.auto_upgrade!
