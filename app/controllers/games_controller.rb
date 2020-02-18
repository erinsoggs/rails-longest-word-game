require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    word = params[:word]
    letters = params[:letters].split('')
    word_valid(letters, word)

    if english_word && word_valid(letters, word)
      @message = 'Good job!'
    elsif english_word == false
      @message = "#{word} is not an english word"
    elsif word_valid(letters, word) == false
      @message = 'Didn\'t use given letters!'
    end
  end

  def english_word
    word = params[:word]
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def word_valid(letters, word)
    word = word.split('')
    word.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end
end
