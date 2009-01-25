module Translator
  class Console  
    # cattr_accessor
    @@provider = nil unless defined? @@provider
    def self.provider; @@provider; end
    def self.provider=(provider); @@provider = provider; end

    def self.prompt
      "\n\n#{@@provider} >> "
    end
  
    def self.config
      yield self
    end

    def self.run
      raise "Console should have a translation provider. Please configure console with #{self}.config { |config| ... }" unless provider
      $stdout << prompt
      $stdout.flush
      while unit = gets do
        $stdout << translate(unit)
        $stdout << prompt
        $stdout.flush        
      end
    end

    def self.translate(phrase)
      phrase.strip!
      options = { :phrase => phrase, :provider => provider.type }
      unit = Unit.first(options) || Unit.new(options)
      # TODO rescue connection error
      unit.translation ||= provider.translate(phrase)
      unit.count +=1
      unit.save
      unit.translation
    end
  end
end