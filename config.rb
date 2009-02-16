module Translator
  class Config
        
    PROMPT = "Contra (q for quit) >> "
    
    BREAK_CHARS = Readline.basic_word_break_characters.delete(" ")
    
    WORD_PROVIDER = LingvoYandex.new
    PHRASE_PROVIDER = Multitran.new
    
  end
end