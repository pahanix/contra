module Parser
  class Base
    attr_reader :url, :default_charset, :xpath
    
    def initialize(url="http://localhost/translate?text=%s", default_charset='utf-8', xpath="//html/body")
      raise ArgumentError, "url should contain %s" unless url =~ /%s/      
      
      @url = url
      @default_charset = default_charset
      @xpath = xpath
    end

    def construct_url(*words)
      url % words.join(' ').strip.gsub(/\s+/, '+')
    end    
        
    def convert_to_default_charset(file)
      Iconv.iconv(default_charset, file.charset, file.read).join
    end
        
    def translate(*words)
      url  = construct_url(*words)
      html = open(url) { |file| convert_to_default_charset(file) }
      parse(html)
    end

    def parse(html)
      page = Hpricot(html)
      (page/@xpath).map{ |item| item.to_plain_text }.join("#{separator}\n")
    end
    alias_method :extract, :parse

    def host
      URI.parse(@url % 'apple').host rescue @url
    end

    def separator
      '_'*80
    end
  
    def to_str
      self.class.to_s
    end
    
    private 
    
    # Clearing [http://link] from Hpricot
    def clear(p)
      p.to_plain_text.gsub(/\n/, "").gsub(/\[.*?\]/, '')
    end
    
  end
end