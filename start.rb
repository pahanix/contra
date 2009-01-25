#!/usr/bin/env ruby
require 'boot'

Translator::Console.config do |config|
  config.provider = LingvoYandex.new
end

Translator::Console.run
