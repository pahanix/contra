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
    
    
    
    describe "#detect_charset" do
      before(:each) do
        @parser = Base.new("localhost?text=%s", "utf-8")
      end
      
      it "should detect encoding as windows-1251" do
        html = '<html><head><meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1251"></head></html>'
        @parser.detect_charset(html).should == 'windows-1251'
        @parser.detect_encoding(html).should == 'windows-1251'
      end

      it "should be case insensate" do
        html = '<html><head><META http-eQuIv="conTEnt-Type" CONTENT="TExt/html; charset=windows-1251"></head></html>'
        @parser.detect_charset(html).should == 'windows-1251'
        @parser.detect_encoding(html).should == 'windows-1251'
      end

      
      it "should detect encoding as utf-8" do
        html = '<html><head><meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8"></head></html>'
        @parser.detect_charset(html).should == 'utf-8'
        @parser.detect_encoding(html).should == 'utf-8'
      end

      it "should detect encoding as utf-8 (default) for unknown encoding" do
        html = '<html><head></head></html>'
        @parser.detect_charset(html).should == 'utf-8'
        @parser.detect_encoding(html).should == 'utf-8'
      end
    end
    
    
    
    describe "#http_request_body" do
      it "should raise URI::InvalidURIError for invalid url" do
        @parser = Base.new
        lambda { @parser.http_request_body("invalid url") }.should raise_error(URI::InvalidURIError)
      end
    end

    
    
    describe "#convert_to_default_charset" do
      it "should return blank string when input is blank" do
        Base.new.convert_to_default_charset(nil).should == ""
        Base.new.convert_to_default_charset("").should == ""
      end
    end
    
    

    describe "#translate & #parse" do
      before(:each) do
        @parser = Base.new
      end
      
      it "should parse received html" do
        @parser.should_receive(:http_request_body).and_return("<html><body>translation</body></html>")
        @parser.translate("word").should == "translation"
      end
      
      it "should parse html" do
        @parser.parse("<html><body>translation</body></html>").should == "translation"
      end
    end
  end
end