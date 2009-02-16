require File.dirname(__FILE__) + '/../spec/spec_helper'

module Translator
  
  describe Console do
    
    before :each do
      @lingvo = LingvoYandex.new
      @multi = Multitran.new
      @console = Console
      
      @console.word = @lingvo
      @console.phrase = @multi      
    end
    
    describe "detecting translation provider" do 
      it "should detect 'concrete mixer' as phrase" do
        @console.detect_provider('concrete mixer').should == @multi
      end

      it "should detect '   concrete mixer' as phrase" do
        @console.detect_provider('   concrete mixer').should == @multi
      end

      it "should detect 'mixer' as word" do
        @console.detect_provider('mixer').should == @lingvo
      end

      it "should detect ' mixer' as word" do
        @console.detect_provider(' mixer').should == @lingvo
      end

      it "should detect ' mixer ' as word" do
        @console.detect_provider(' mixer').should == @lingvo
      end
    end
    
    
    
    describe "::terminal?" do
      it "should detect q as terminal" do
        @console.terminal?('q').should be_true
      end
      
      it "should NOT detect word as terminal" do
        @console.terminal?('word').should be_false
      end
    end
    
    
    
    describe "::completion_proc" do
      before :each do
        @tractor  = Unit.new(:phrase => 'tractor')
        @trace    = Unit.new(:phrase => 'trace')
        @war      = Unit.new(:phrase => 'war')
        @war_seat = Unit.new(:phrase => 'war seat')
        @war_down = Unit.new(:phrase => 'war down')
      end
      
      it "should NOT complete completed single word" do
        Unit.should_receive(:all).and_return [@tractor]
        @console.completion_proc.call('tractor').should be_nil
      end
      
      it "should complete single word if it is not full" do
        Unit.should_receive(:all).and_return [@tractor]
        @console.completion_proc.call('tract').should == ["tractor"]
      end

      it "should provide uniq sorted versions of completion" do
        Unit.should_receive(:all).and_return [@tractor, @trace, @tractor]
        @console.completion_proc.call('tra').should == ["trace", "tractor"]
      end
      
      it "should provide versions with spaces even if single word is complete" do
        Unit.should_receive(:all).and_return [@war, @war_seat, @war_down]
        @console.completion_proc.call('war').should == ["war", "war down", "war seat"]
      end
      
    end
    
    
    
    describe "::translate" do

      before(:each) do
        @abracadabra = Unit.new :phrase => 'abracadabra'
      end

      def stub_translation_with(translation)
        @console.word.stub!(:translate).and_return(translation)
        @console.phrase.stub!(:translate).and_return(translation)        
      end

      def should_not_remote_translate
        @console.word.should_not_receive(:translate)
        @console.phrase.should_not_receive(:translate)
      end
      
      it "should not translate blank line" do
        should_not_remote_translate
        @console.translate(nil).should be_blank
        @console.translate(" ").should be_blank
        Unit.should_not_receive(:find_or_create)
      end
      
      it "should not save blank translation" do
        stub_translation_with("")
        Unit.should_receive(:find_or_create).and_return(@abracadabra)
        @console.translate('abracadabra').should be_blank
        @abracadabra.should_not_receive(:save)
        
      end
    end
  end

end
