class LingvoYandex < Translator::Base
  
  def initialize
    super("http://lingvo.yandex.ru/en?text=%s&lang=en&search_type=lingvo&st_translate=on", 'utf-8', 'p')
  end  
  
  def extract(html)
    # Direct parsing does not working because of invalid html of the lingvo.yandex.ru page
    from  = Regexp.escape('<script language="JavaScript" src="http://img.yandex.net/slovari/i/lvmsgs.js"></script>')
    to    = Regexp.escape('<iframe id="dataFrame" src="about:blank"></iframe>')
    body = html.match(/#{from}(.*)#{to}/m)[1] rescue ''
    h = Hpricot(body)
    h.search("p").map{|p| clear(p) }.join("\n")
  end
  
  def to_s
    "Lingvo.Yandex"
  end
  
  private 
  
  # Clearing [http://link] from Hpricot ?
  def clear(p)
    p.to_plain_text.gsub(/\n/, "").gsub(/\[.*?\]/, '')
  end
end