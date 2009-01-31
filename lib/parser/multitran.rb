class Multitran < Parser::Base
  
  def initialize
    super("http://multitran.ru/c/m.exe?l1=1&l2=2&s=%s", 'utf-8')
  end
  
  def parse(html)
    html.gsub!("&nbsp;", " ") # if we don't remove '&nbsp;' here we will have strange '?' symbols in the output
    
    # Direct parsing does not working because of invalid html
    from  = /<\/form>\s*<div><\/div>/
    to    = /<table border="0" cellpadding="0" cellspacing="0" width="100%" height="2"/
    body = html.match(/#{from}(.*?)#{to}/m)[1] rescue ''

    table = (Hpricot(body)/"table").first

    output = []

    table.search("//td").each do |td|
      case td.attributes['width']
      when "100%"
        word = (td/"//a").first.to_plain_text.gsub(/\[.*?\]/, "")
        unit = (td/"//em").first
        output << (unit ? "#{unit.to_plain_text} " : "") + word
      when "1%" 
        output << (td/"//a/i")[0].to_plain_text
      else
        output << td.to_plain_text.gsub(/\[.*?\]/, "")
        output << separator        
      end
    end
    output.join("\n")
  end
  
  def to_s
    "Multitran"
  end
  
  private
  
  # clear from "[.gif" "].gif" filenames
  def clear(html)
    super Hpricot(html.to_s.gsub(/[\[\]]\.gif/, ''))
  end
end