require File.dirname(__FILE__) + '/../spec_helper'

include Utils # for method load_from_file

describe Multitran do
  
  before(:each) do
    @parser = Multitran.new
  end
  
  describe "initialization" do
    it "should be kind of Parser::Base" do
      @parser.should be_kind_of(Parser::Base)
    end
    
    it "should have lingvo.yandex.ru host" do
      @parser.host.should == 'multitran.ru'
    end
  end
  
  describe "#parse" do
    it "should parse multitran.html as expected result" do
      html = @parser.convert_to_default_charset load_from_file('multitran.html')
      # save_to_file(html, "multitran.utf8.html")
      expected = load_from_file('multitran.expected')
      result = @parser.parse(html)
      # save_to_file(result, "multitran.result")
      result.should == expected
    end
    
    it "should parse multitran2.html as expected result" do
      html = @parser.convert_to_default_charset load_from_file('multitran2.html')
      # save_to_file(html, "multitran2.utf8.html")
      expected = load_from_file('multitran2.expected')
      result = @parser.parse(html)
      # save_to_file(result, "multitran2.result")
      result.should == expected
    end
    
  end
end