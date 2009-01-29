module Translator
  class Console  
    cattr_accessor :provider

    def self.prompt
      "\n\n#{provider} >> "
    end
  
    def self.config
      yield self
    end

    def self.init
      raise "Console should have a translation provider. Please configure console with #{self}.config { |config| ... }" unless provider
      History.new
      Readline.completion_proc = lambda { |unit| Unit.all(:phrase.like => "#{unit}%").map{|u| u.phrase}.uniq.sort }
    end

    def self.run
      init
      loop do
        unit = Readline::readline(prompt, true)
        break if terminal?(unit)
        puts execute(unit)
      end
    end

    def self.translate(phrase)
      unit = Unit.find_or_create(:phrase => phrase, :provider => provider.type)
      unit.translation ||= provider.translate(phrase)
      unit.count +=1
      unit.save
      unit.translation
    rescue SocketError => e
      "Cannot connect to the host #{provider.host}\n"
    end
    
    def self.terminal?(unit)
      unit.downcase.in? [":stop", ":exit", ":quit", ":term"]
    end
    
    def self.command?(unit)
      unit[0..0] == ":"
    end
    
    def self.execute(unit)
      if command?(unit)
        "EXECUTED COMMAND #{unit}"
      else
        translate(unit)
      end
    end
  end
end
