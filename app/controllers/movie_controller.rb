class MovieController < ApplicationController
  def search
    @movies = Movie.all
  end

  def result
    SearchMovie.new(params[:search][:query]).get_result
    redirect_to root_path
  end
end
