require File.dirname(__FILE__) + '/../spec_helper'

include Utils # for method load_from_file

describe LingvoYandex do
  
  before(:each) do
    @parser = LingvoYandex.new
  end
  
  describe "#initialize" do
    it "should be kind of Parser::Base" do
      @parser.should be_kind_of(Parser::Base)
    end
    
    it "should have lingvo.yandex.ru host" do
      @parser.host.should == 'lingvo.yandex.ru'
    end
  end
  
  describe "#parse" do
    it "should parse html as expected result" do
      html      = load_from_file('lingvo_yandex.html')
      expected  = load_from_file('lingvo_yandex.expected')
      @parser.parse(html).should == expected
    end
  end
end