require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @userinput = params[:userinput]
    @letters = params[:letters]
  if included?(@userinput.upcase, @letters)
    if english_word?(@userinput)

      if session[:current_word_size].nil?
        session[:current_word_size] = @userinput.length
      else
        session[:current_word_size] += @userinput.length
      end
      @score = session[:current_word_size]
      @message = "Well done !"
    else
      @score = session[:current_word_size]
      @message = "Not an english word"
    end
  else
    @score = session[:current_word_size]
    @message = "Not in the grid"
  end
end

private

def included?(userinput, letters)
  userinput.chars.all? { |letter| userinput.count(letter) <= letters.count(letter) }
end

def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
end

end
