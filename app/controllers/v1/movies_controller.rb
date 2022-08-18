class V1::MoviesController < ApplicationController
  def user_validation
    user, error, status = UsersHelper::Validator.valid_user_token?(request.headers['Authorization'])
    unless user
      render json: { 'error:': error }, status: status
      return
    end
    user
  end

  def create
    return unless user_validation

    movie = Movie.new(movie_params)
    params[:genres].each do |genre|
      movie.genres << Genre.find_by(name: genre)
    end
    params[:characters].each do |character|
      movie.characters << Character.find_by(name: character)
    end
    if movie.save
      render json: movie.to_json(only: %I[title release_date image]), status: :ok
    else
      render json: { 'error:': movie.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def index
    return unless user_validation

    movies = movies_filter

    render json: movie_index(movies).to_json(only: %I[id title image release_date]), status: :ok
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def show
    return unless user_validation

    movie = Movie.find(params[:id])
    render json: movie_show(movie).to_json, status: :ok
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def update
    return unless user_validation

    movie = Movie.find(params[:id])
    if movie.update(movie_params)
      render json: movie.to_json, status: :ok
    else
      render json: { 'error:': movie.errors.first.message }, status: :bad_request
    end
  end

  def destroy
    return unless user_validation

    movie = Movie.find(params[:id])
    if movie.destroy
      render json: { message: 'Movie deleted' }, status: :ok
    else
      render json: { 'error:': movie.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  private

  def movie_params
    params.permit(:title, :release_date, :rating, :image)
  end

  def movies_filter
    if params[:title]
      Movie.where('title ~* ?', params[:title])
    elsif params[:genre]
      Movie.joins(:genres).where('genres.name ~* ?', params[:genre])
    elsif params[:order]
      if params[:order] == 'asc'
        Movie.order(:release_date)
      else
        Movie.order(release_date: :desc)
      end
    else
      Movie.all
    end
  end

  def movie_index(movies)
    movies.map do |movie|
      {
        id: movie.id,
        title: movie.title,
        release_date: movie.release_date,
        image: url_for(movie.image)
      }
    end
  end

  def movie_show(movie)
    {
      id: movie.id,
      title: movie.title,
      release_date: movie.release_date,
      rating: movie.rating,
      image: url_for(movie.image),
      characters: movie.characters,
      genres: movie.genres
    }
  end
end
