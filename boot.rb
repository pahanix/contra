require 'rubygems'
# require 'extlib' # included in dm-core
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'readline'
require 'hpricot'
require 'open-uri'
require 'iconv'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/dictionary.sqlite3")
DataObjects::Sqlite3.logger = DataObjects::Logger.new('log/dictionary.log', :debug) # :off, :fatal, :error, :warn, :info, :debug

Dir["#{Dir.pwd}/{translator,lib,models}/**/*.rb"].each { |f| require f }

require 'config'

# DataMapper.auto_migrate!
DataMapper.auto_upgrade!
