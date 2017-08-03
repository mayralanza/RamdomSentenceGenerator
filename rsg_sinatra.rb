#Mayra Lanza
#Web Apps Dev
require 'sinatra'
require './rsg.rb'

get '/' do
    erb :home
end

post '/rsg' do
  if params['grammar']
    @grammar = params['grammar']
    # Input validation, only allows your typical characters for file names
    @grammar = @grammar.gsub(/[^A-Za-z\-\.]/, '')
    filename = "grammars/#{@grammar}"
    filename += '.g' unless filename.end_with? '.g'
    # If the filename does not exist in the grammars folder
    if !FileTest.exists? filename
      erb :error
    else
      @sentence = rsg(@grammar)
      erb :rsg
    end
  end
end