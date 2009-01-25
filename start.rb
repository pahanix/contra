#!/usr/bin/env ruby
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require f }

Translator::Console.config do |config|
  config.provider = LingvoYandex.new
end

Translator::Console.run
