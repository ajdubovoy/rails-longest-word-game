require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (('a'..'z').to_a * 10).sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(" ")
    is_english_word = english_word? @word
    is_in_grid = in_grid? @word, @letters
    @results = evaluate_results(is_english_word, is_in_grid)
  end

  private

  def english_word?(word)
    api_results = open('https://wagon-dictionary.herokuapp.com/' + word).read
    results = JSON.parse(api_results)
    return results["found"]
  end

  def in_grid?(word, letters)
    grid_temp = letters
    attempt_letters = word.downcase.split("")
    return attempt_letters.all? do |letter|
      includes = grid_temp.include? letter
      grid_temp -= [letter] if includes
      includes
    end
  end

  def evaluate_results(is_english_word, is_in_grid)
    pretty_grid = @letters.join(", ")
    if is_english_word && is_in_grid
      return "<strong>Congratulations!</strong> #{@word} is a valid English word!"
    elsif is_english_word && !is_in_grid
      return "Sorry, but <strong>#{@word}</strong> can't be built out of #{pretty_grid}"
    elsif !is_english_word && is_in_grid
      return "Sorry, but <strong>#{@word}</strong> does not seem to be a valid English word..."
    else
      return "Sorry, but <strong>#{@word}</strong> does not seem to be a valid English word..."
    end
  end
end
