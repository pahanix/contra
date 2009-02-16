#
# Some ideas and snippents for Readline::HISTORY are taken from Wirble gem 0.1.2
#
module Translator
  class History
    DEFAULTS = {
      :path => "./.history",
      :max_size => 1000,
      :perms => File::WRONLY | File::CREAT | File::TRUNC
    }

    def initialize(opts={})
      @options = DEFAULTS.merge(opts || {})
      return unless defined? Readline::HISTORY
      load_history
      Kernel.at_exit { save_history }
    end

    def cfg(key)
      @options[key.intern]
    end

    def history_lines
      real_path = File.expand_path(cfg('path'))
      File.open(real_path, 'w+'){ |file| file } unless File.exist?(real_path)
      lines = File.readlines(real_path).map { |line| line.chomp }
    end
    
    def load_history
      Readline::HISTORY.push(*history_lines)
    end
    
    def save_history
      path, max_size, perms = %w{path max_size perms}.map { |v| cfg(v) }
      
      # reverse.uniq.reverse uniqifies from last to first instead of first to last as usual
      lines = (history_lines + Readline::HISTORY.to_a).reverse.uniq.reverse
      lines = lines[-max_size, -1] if lines.size > max_size
      
      # write the history file
      real_path = File.expand_path(path)
      File.open(real_path, perms) { |fh| fh.puts lines }
    end
  end
end