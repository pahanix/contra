module Utils 
  def save_to_file(html, filename)
    File.open(File.join(File.dirname(__FILE__), '..', 'assets', filename) , "w"){|f| f.write(html)}
  end
  
  def load_from_file(filename)
    File.open(File.join(File.dirname(__FILE__), '..', 'assets', filename) , "r"){|f| f.read}
  end
  
  def url_to_file(url, filename)
    save_to_file(Parser::Base.new.http_request_body(url), filename)
  end  
end
