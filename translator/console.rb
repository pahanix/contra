module Translator
  class Console  
    unless defined? @@provider
      @@provider = nil
    end

    def self.provider=(provider)
      @@provider = provider
    end

    def self.provider
      @@provider
    end

    def self.prompt
      "\n\n#{@@provider} >> "
    end
  
    def self.config
      yield self
    end

    def self.run
      raise "Console should have a translation provider. Please configure console with #{self}.config { |config| ... }" unless provider
      print prompt
      while unit = gets do
        print provider.translate(unit.strip)
        print prompt
      end
    end
  end
end