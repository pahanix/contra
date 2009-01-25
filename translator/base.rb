require 'rubygems'
require 'hpricot'
require 'net/http'
require 'iconv'

module Translator
  class Base
    CHARSET = /<meta HTTP-EQUIV="Content-Type" CONTENT="text\/html; charset=([-\w\d]+)">/im unless defined? CHARSET

    # @params
    # url should contain %s
    def initialize(url="http://localhost/translate?text=%s", default_charset='utf-8', xpath="//html/body")
      @url = url
      @default_charset = default_charset
      @xpath = xpath
    end

    def charset(html)
      html.match(CHARSET)[1] rescue @default_charset
    end

    def extract(html)
      page = Hpricot(html)
      puts page
      output = @words.join(' ')
      (page/@xpath).each do |item|
        output << item.to_plain_text
        output << separator
      end
    end

    def translate(*words)
      @words = words
      url = @url % @words.join('+')
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
      res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
      extract Iconv.iconv(@default_charset, charset(res.body), res.body).to_s
    end

    def separator
      '='*60
    end
  
    def to_s
      "Base Translator"
    end
  end
end