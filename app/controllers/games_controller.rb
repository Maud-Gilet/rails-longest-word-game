require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letters_array = ('A'..'Z').to_a
    my_grid = []
    10.times do
      my_grid << letters_array.sample
    end
    @letters = my_grid
  end

  def score
    @letters = params[:letters_token]
    @word = params[:try]

    url = "https://wagon-dictionary.herokuapp.com/#{@word.downcase}"
    word_a = open(url).read
    word_characteristics = JSON.parse(word_a)

    grid_hash = {}
    @letters.chars.each do |letter|
      grid_hash[letter] = @letters.count(letter)
    end

    @word.upcase.chars.each do |letter|
      if grid_hash.key?(letter)
        if grid_hash[letter].positive?
          grid_hash[letter] -= 1
        else
          return @score = "Sorry but #{@word.upcase} can't be built out of #{@letters}."
        end
      else
        return @score = "Sorry but #{@word.upcase} can't be built out of #{@letters}."
      end
    end

    if word_characteristics['found'] == true
      @score = "Congratulations! #{@word.upcase} is a valid English word!"
    else
      @score = "Sorry but #{@word.upcase} does not seem to be a valid English word."
    end
    @score
  end
end

