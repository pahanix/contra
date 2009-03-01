require 'rubygems'
require 'sinatra'
require 'haml'

# Loads all Contra classes
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'boot')

before do
  response['Content-Type'] = 'text/html; charset=utf-8'
end

get '/' do
  @title = "Alphabetically"
  @units = Unit.all(:order => [:phrase.asc])
  haml :stats
end

get '/top' do
  @title = "Top asked words"
  @units = Unit.all(:order => [:count.desc])
  haml :stats
end

get '/last' do
  @title = "Last asked words"  
  @units = Unit.all(:order => [:updated_at.desc])
  haml :stats  
end

get '/translate/:word' do
  @unit = Unit.first(:phrase => params[:word])
  if @unit 
    @title = "Translation: #{@unit.phrase}"
    haml(:translation) 
  else
    not_found
  end
end

not_found do
  haml "Translation was not found"
end