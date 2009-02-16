module Translator
  class Console  
    cattr_accessor :word, :phrase, :prompt

    def self.welcome
      File.read('welcome')
    end

    def self.init
      History.new
      
      Readline.basic_word_break_characters = Config::BREAK_CHARS
      Readline.completion_proc = self.completion_proc

      self.word    = Config::WORD_PROVIDER
      self.phrase  = Config::PHRASE_PROVIDER      
      self.prompt  = Config::PROMPT
    end
    
    def self.run
      init
      $stdout.puts welcome
      loop do
        unit = Readline::readline(prompt, true)
        next  if unit.blank?
        break if terminal?(unit)
        translation = translate(unit)
        $stdout.puts(translation) unless translation.blank?
      end
    end

    def self.translate(line)
      return if line.blank?

      line.strip!
      provider = detect_provider(line)
      
      unit = Unit.find_or_create(:phrase => line, :provider => "#{provider}")
      unit.translation ||= provider.translate(line)

      return if unit.translation.blank?

      unit.count +=1
      unit.save
      
      format_output % [provider, line, unit.translation]
      
    rescue SocketError => e
      "Cannot connect to the host #{provider.host}\n"
    end
    
    def self.format_output
      [" ", "%s: %s", " ", "%s", " "].join("\n")
    end
    
    def self.completion_proc
      Proc.new do |unit| 
        completions = Unit.all(:phrase.like => "#{unit.lstrip}%").map{|u| u.phrase}.uniq.sort
        completions.first == unit && completions.size == 1 ? nil : completions
      end
    end
      
    def self.detect_provider(line)
      line.strip !~ / / ? word : phrase
    end
    
    def self.terminal?(unit)
      unit.downcase.in? ["q", "stop", "exit", "quit"]
    end
  end
end
