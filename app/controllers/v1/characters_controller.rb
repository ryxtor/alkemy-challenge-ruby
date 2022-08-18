class V1::CharactersController < ApplicationController
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

    character = Character.new(character_params)
    if character.save
      render json: character.to_json(only: %I[name age weight history image]), status: :ok
    else
      render json: { 'error:': character.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def index
    return unless user_validation

    characters = if params[:name]
                   Character.where('name ~* ?', params[:name])
                 elsif params[:age]
                   Character.where(age: params[:age])
                 elsif params[:movie]
                   Character.where('movie ~* ?', params[:movie])
                 else
                   Character.all
                 end

    render json: character_index(characters).to_json(only: %I[id name image]), status: :ok
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def show
    return unless user_validation

    character = Character.find(params[:id])
    render json: character_show(character).to_json(only: %I[id name age weight history image]), status: :ok
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def update
    return unless user_validation

    character = Character.find(params[:id])
    if character.update(character_params)
      render json: character.to_json(only: %I[id name age weight history image]), status: :ok
    else
      render json: { 'error:': character.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def destroy
    return unless user_validation

    character = Character.find(params[:id])
    if character.destroy
      render json: { message: 'Character deleted' }, status: :ok
    else
      render json: { 'error:': character.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  private

  def character_index(characters)
    characters.map do |character|
      { id: character.id, name: character.name, age: character.age, weight: character.weight,
        history: character.history, image: url_for(character.image) }
    end
  end

  def character_show(character)
    { id: character.id, name: character.name, age: character.age, weight: character.weight,
      history: character.history, image: url_for(character.image) }
  end

  def character_params
    params.permit(:name, :age, :weight, :history, :image)
  end
end
