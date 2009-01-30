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
      
      # we remove space from word break chars because it should complete entire phrase
      Readline.basic_word_break_characters = Readline.basic_word_break_characters.delete(" ")
      
      Readline.completion_proc = Proc.new do |unit| 
        unit.strip!
        completions = Unit.all(:phrase.like => "#{unit}%").map{|u| u.phrase}.uniq.sort
        completions[0] == unit ? nil : completions
      end
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
      unit = Unit.find_or_create(:phrase => phrase.strip, :provider => provider.type)
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
