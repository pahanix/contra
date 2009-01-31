require 'rubygems'
require 'hpricot'
require 'net/http'
require 'iconv'

module Parser
  class Base
    attr_reader :url, :default_charset, :xpath
    
    CHARSET_REGEXP = /<meta HTTP-EQUIV="Content-Type" CONTENT="text\/html; charset=([-\w\d]+)">/im unless defined? CHARSET_REGEXP

    def initialize(url="http://localhost/translate?text=%s", default_charset='utf-8', xpath="//html/body")
      raise ArgumentError, "url should contain %s" unless url =~ /%s/      
      
      @url = url
      @default_charset = default_charset
      @xpath = xpath
    end

    def detect_charset(html)
      html.match(CHARSET_REGEXP)[1] rescue @default_charset
    end
    alias_method :detect_encoding, :detect_charset

    def construct_url(*words)
      url % words.join(' ').strip.gsub(/\s+/, '+')
    end

    def http_request_body(url)
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
      res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
      res.body
    end
    
    def convert_to_default_charset(html)
      Iconv.iconv(@default_charset, detect_charset(html), html).to_s
    end
    
    def translate(*words)
      parse(
        convert_to_default_charset(
          http_request_body(
            construct_url(*words)
          )
        )
      )
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