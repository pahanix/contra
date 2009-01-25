class Multitran < Translator::Base
  
  def initialize
    super("http://multitran.ru/c/m.exe?l1=1&l2=2&s=%s", 'utf-8')
  end
  
  def extract(html)
    html.gsub!("&nbsp;", " ") # if we don't remove '&nbsp;' here we will have strange '?' symbols in the output
    page = Hpricot(html)
    #/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr/td/table
    table = page.search("//table//table//table").find do |table| 
      table.search("//a").any? { |a| a.attributes['href'] =~ /m.exe/ }
    end
    
    output = []
    # We can not use '<tr>' because of invalid html on the page
    #
    # table.search("//tr").each do |tr|
    #   tds = tr.search("//td")
    #   output << tr.to_html
    #   if tds[0].attributes['width'] == "100%"
    #     word = (tds/"//a").first.to_plain_text.gsub(/\[.*?\]/, "")
    #     unit = (tds/"//em").first.to_plain_text
    #     output << "#{unit} #{word}"
    #   else
    #     output << (tds/"//a/i")[0].to_plain_text rescue '-'*60
    #     output << tds[1].to_plain_text.gsub(/\[.*?\]/, "") rescue '*'*60
    #   end
    #   output << '='*60
    # end
    
    table.search("//td").each do |td|
      output << td.to_original_html
      case td.attributes['width']
      when "100%"
        word = (td/"//a").first.to_plain_text.gsub(/\[.*?\]/, "")
        unit = (td/"//em").first.to_plain_text
        output << "#{unit} #{word}"
        output << separator
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
end