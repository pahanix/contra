require File.dirname(__FILE__) + '/../spec_helper'

module Parser

  describe Base do
    
    describe "#initialize" do
      it "should be instance of Parser::Base" do
        Base.new.should be_instance_of(Parser::Base)
      end
      
      it "should raise ArgumentError if url contain NO '%s'" do
        lambda { Base.new("localhost") }.should raise_error(ArgumentError)
      end

      it "should NOT raise any other error exept of ArgumentError if url contain NO '%s'" do
        lambda { Base.new("localhost") }.should_not raise_error(NoMethodError) 
      end

    end
    
    
    
    describe "#construct_url" do

      before :each do
        @parser = Base.new("localhost?text=%s")
      end

      it "should construct url from words" do
        url = @parser.construct_url("on", "the", "ropes")
        URI.parse(url).query.should == "text=on+the+ropes"
      end
    
      it "should construct url from line" do
        url = @parser.construct_url("on the ropes")
        URI.parse(url).query.should == "text=on+the+ropes"
      end

      it "should construct url from joined words" do
        url = @parser.construct_url("on the","ropes")
        URI.parse(url).query.should == "text=on+the+ropes"
      end

      it "should construct url ignoring extra spaces" do
        url = @parser.construct_url("   on   the     ropes    ")
        URI.parse(url).query.should == "text=on+the+ropes"
      end
    end
    
    
    
    describe "#translate & #parse" do
      before(:each) do
        @parser = Base.new
        
        @html = StringIO.new("<html><body>translation</body></html>")
        @html.stub!(:charset).and_return('utf-8')
      end
      
      it "should parse received html" do
        @parser.should_receive(:open).and_return(@html)
        @parser.translate("word").should == "translation"
      end
      
      it "should parse html" do
        @parser.parse("<html><body>translation</body></html>").should == "translation"
      end
    end
  end
end