class GamesController < ApplicationController
  def new
    @letters = (('a'..'z').to_a * 10).sample(10)
  end

  def score
  end
end
