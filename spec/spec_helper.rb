$TESTING=true

require "rubygems"
require "spec"
require "yaml"

require File.join(File.dirname(__FILE__), '..', 'boot')

require File.join(File.dirname(__FILE__), 'utils', 'file')

include Utils

# DataMapper.setup(:test, "sqlite3://:memory:")