require 'rubygems'
# require 'extlib' # included in dm-core
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'readline'
require 'hpricot'
require 'open-uri'
require 'iconv'

ROOT = File.dirname(File.expand_path(__FILE__))

DataMapper.setup(:default, "sqlite3://#{ROOT}/db/dictionary.sqlite3")
DataObjects::Sqlite3.logger = DataObjects::Logger.new("#{ROOT}/log/dictionary.log", :debug) # :off, :fatal, :error, :warn, :info, :debug

Dir["#{ROOT}/{translator,lib,models}/**/*.rb"].each { |f| require f }

# Load config after all stuff is loaded
require "#{ROOT}/config"

# DataMapper.auto_migrate!
DataMapper.auto_upgrade!
