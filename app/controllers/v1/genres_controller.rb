class V1::GenresController < ApplicationController
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

    genre = Genre.new(genre_params)
    if genre.save
      render json: genre.to_json(only: %I[id name]), status: :ok
    else
      render json: { 'error:': genre.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def index
    return unless user_validation

    genres = if params[:name]
               Genre.where('name ~* ?', params[:name])
             else
               Genre.all
             end

    render json: genre_index(genres).to_json(only: %I[id name]), status: :ok
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def show
    return unless user_validation

    genre = Genre.find(params[:id])
    render json: genre_show(genre).to_json(only: %I[id name]), status: :ok
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def update
    return unless user_validation

    genre = Genre.find(params[:id])
    if genre.update(genre_params)
      render json: genre.to_json(only: %I[id name]), status: :ok
    else
      render json: { 'error:': genre.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def destroy
    return unless user_validation

    genre = Genre.find(params[:id])
    if genre.destroy
      render json: { message: 'Genre deleted' }, status: :ok
    else
      render json: { 'error:': genre.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  private

  def genre_params
    params.permit(:name, :image)
  end

  def genre_index(genres)
    genres.map do |genre|
      { id: genre.id, name: genre.name, image: url_for(genre.image) }
    end
  end

  def genre_show(genre)
    { id: genre.id, name: genre.name, image: url_for(genre.image), movies: genre.movies }
  end
end
