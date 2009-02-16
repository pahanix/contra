require File.dirname(__FILE__) + '/../spec_helper'
require 'digest/sha1'

describe Multitran do
  
  before(:each) do
    @parser = Multitran.new
  end
  
  describe "#initialize" do
    it "should be kind of Parser::Base" do
      @parser.should be_kind_of(Parser::Base)
    end
    
    it "should have lingvo.yandex.ru host" do
      @parser.host.should == 'multitran.ru'
    end
  end
  
  
  describe "#parse" do
    it "should parse multitran.html as expected result" do
      html = read_asset_file('multitran.html', 'windows-1251')
      # save_to_asset_file(html, "multitran.utf8.html")
      expected = read_asset_file('multitran.expected')
      
      result = @parser.parse(html)
      # save_to_asset_file(result, "multitran.result")

      # spaces don't matter
      result.gsub(/\s+/, '').should == expected.gsub(/\s+/, '')
    end
    
    it "should parse multitran2.html as expected result" do
      html = read_asset_file('multitran2.html', 'windows-1251')
      # save_to_asset_file(html, "multitran2.utf8.html")
      expected = read_asset_file('multitran2.expected')
      
      result = @parser.parse(html)
      # save_to_asset_file(result, "multitran2.result")
      
      # spaces don't matter
      result.gsub(/\s+/, '').should == expected.gsub(/\s+/, '')
    end
    
  end
end