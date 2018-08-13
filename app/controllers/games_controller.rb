require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10).collect { ('a'..'z').to_a.sample.upcase }
  end

  def score
    @grid = params[:grid].split(' ')
    @word = params[:word]
    @score = @word.length
    @message = message
  end

  def in_grid?
    @word.upcase.chars.all? { |l| @grid.include?(l) && @word.length <= 10 }
  end

  def valid?
    srz = open("https://wagon-dictionary.herokuapp.com/#{@word}")
    word = JSON.parse(srz.read)
    word['found']
  end

  def message
    if in_grid?
      if valid?
        "Congrats! '#{@word.capitalize}' is valid.\nYou score: #{@score} points!"
      else
        "'#{@word.capitalize}' ain't English"
      end
    else
      "'#{@word.capitalize}' isn't in the grid"
    end
  end
end
