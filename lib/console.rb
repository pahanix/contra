module Translator
  class Console  
    cattr_accessor :word, :phrase

    def self.welcome
      File.open('welcome', 'r'){ |file| file.read }
    end

    def self.prompt
      "Contra (q for quit) >> "
    end
  
    def self.config
      yield self
    end

    def self.init
      # raise "Console should have a translation provider. Please configure console with #{self}.config { |config| ... }" unless provider
      History.new
      
      # we remove space from word break chars because it should complete entire phrase
      Readline.basic_word_break_characters = Readline.basic_word_break_characters.delete(" ")
      # Readline.basic_word_break_characters.delete!(" ") doesn't work!
      
      Readline.completion_proc = Proc.new do |unit| 
        unit.strip!
        completions = Unit.all(:phrase.like => "#{unit}%").map{|u| u.phrase}.uniq.sort
        completions[0] == unit ? nil : completions
      end
    end

    def self.run
      init
      puts welcome
      loop do
        unit = Readline::readline(prompt, true)
        next  if unit.blank?
        break if terminal?(unit)
        puts execute(unit)
      end
    end

    def self.translate(line)
      line.strip!
      return "" if line.blank?
      
      # define mode of translation words for Lingvo, phrase for Multitran
      provider = (line !~ / / ? word : phrase)
      
      unit = Unit.find_or_create(:phrase => line.strip, :provider => "#{provider}")
      unit.translation ||= provider.translate(line)
      return "" if unit.translation.blank?
      unit.count +=1
      unit.save
      
      [" ", "#{provider}: #{line}", " ", unit.translation, " "].join("\n")
    rescue SocketError => e
      "Cannot connect to the host #{provider.host}\n"
    end
    
    def self.terminal?(unit)
      unit.downcase.in? ["q", ":stop", ":exit", ":quit", ":term"]
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
