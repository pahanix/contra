require 'readline'

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
      load_history!
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

    #
    # Some ideas and snippents for Readline::HISTORY are taken from Wirble gem 0.1.2
    #

    @@cfg = {
      :path => "./.history",
      :max_size => 1000,
      :perms => File::WRONLY | File::CREAT | File::TRUNC
    }

    def self.cfg(key)
      @@cfg[key.intern]
    end

    def self.history_lines
      real_path = File.expand_path(cfg('path'))
      File.open(real_path, 'w+'){ |file| file } unless File.exist?(real_path)
      lines = File.readlines(real_path).map { |line| line.chomp }
    end
    
    def self.load_history!
      Readline::HISTORY.push(*history_lines)
    end
    
    def self.save_history!
      path, max_size, perms = %w{path max_size perms}.map { |v| cfg(v) }
      
      # reverse.uniq.reverse uniqifies from last to first instead of first to last as usual
      lines = (history_lines + Readline::HISTORY.to_a).reverse.uniq.reverse
      lines = lines[-max_size, -1] if lines.size > max_size
      
      # write the history file
      real_path = File.expand_path(path)
      File.open(real_path, perms) { |fh| fh.puts lines }
    end
        
    def self.terminal?(unit)
      if [":stop", ":exit", ":quit", ":term"].include?(unit.downcase)
        save_history!
        return true
      end
      false
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
