module Utils 
  
  def open_asset_file(filename, mode)
    yield File.open(File.join(File.dirname(__FILE__), '..', 'assets', filename) , mode)
  end
  
  def save_to_asset_file(html, filename)
    open_asset_file(filename, "w") {|file| file.write html }
  end
  
  def read_asset_file(filename, charset='utf-8')
    open_asset_file(filename, "r") { |file| Iconv.iconv('utf-8', charset, file.read).join }
  end
  
  def url_to_asset_file(url, filename)
    html = open(url){ |io| io.read }
    save_to_asset_file(html, filename)
  end  
  
end
