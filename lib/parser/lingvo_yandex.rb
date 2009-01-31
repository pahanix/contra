class LingvoYandex < Parser::Base
  
  def initialize
    super("http://lingvo.yandex.ru/en?text=%s&lang=en&search_type=lingvo&st_translate=on", 'utf-8', 'p')
  end  
  
  def parse(html)
    # Direct parsing does not working because of invalid html of the lingvo.yandex.ru page
    from  = Regexp.escape('<script language="JavaScript" src="http://img.yandex.net/slovari/i/lvmsgs.js"></script>')
    to    = Regexp.escape('<iframe id="dataFrame" src="about:blank"></iframe>')
    body = html.match(/#{from}(.*)#{to}/m)[1] rescue ''
    Hpricot(body).search("p").map{|p| clear(p) }[0..-2].join("\n")
  end
  
  def to_s
    "Lingvo.Yandex"
  end
end