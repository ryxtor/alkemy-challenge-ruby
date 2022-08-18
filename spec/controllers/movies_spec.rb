require 'rails_helper'

RSpec.describe V1::MoviesController, type: :controller do
  before(:all) do
    @user = User.create(name: 'John Doe', email: 'test@test.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG')
    @character = Character.create(name: 'test', age: 30, weight: 80, history: 'History',
                                  image: fixture_file_upload('tree.jpg'))
    @genre = Genre.create(name: 'test', image: fixture_file_upload('tree.jpg'))
    @movie = Movie.create(title: 'test', image: fixture_file_upload('tree.jpg'), release_date: '2020-01-01', rating: 5)
    @movie.genres << @genre
    @movie.characters << @character
    @movie.save
  end

  after(:all) do
    User.destroy_all
    Character.destroy_all
    Genre.destroy_all
    Movie.destroy_all
  end

  describe 'Create movie' do
    it 'should create movie' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { title: 'test', image: fixture_file_upload('tree.jpg'), release_date: '2020-01-01',
                              rating: 5, genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:success)
    end

    it 'should not create movie without title' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { title: '', image: fixture_file_upload('tree.jpg'), release_date: '2020-01-01',
                              rating: 5, genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create movie without image' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { title: 'test', image: nil, release_date: '2020-01-01',
                              rating: 5, genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create movie without release_date' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { title: 'test', image: fixture_file_upload('tree.jpg'), release_date: '',
                              rating: 5, genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create movie without rating' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { title: 'test', image: fixture_file_upload('tree.jpg'), release_date: '2020-01-01',
                              rating: '', genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create movie without genres' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { title: 'test', image: fixture_file_upload('tree.jpg'), release_date: '2020-01-01',
                              rating: 5, genres: [], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create movie without characters' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { title: 'test', image: fixture_file_upload('tree.jpg'), release_date: '2020-01-01',
                              rating: 5, genres: [@genre.name], characters: [] }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Get movies' do
    it 'should get all movies' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should get movies by genre' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index, params: { genre: @genre.name }
      expect(response).to have_http_status(:success)
    end

    it 'should get movies by title' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index, params: { title: @movie.title }
      expect(response).to have_http_status(:success)
    end

    it 'should get movies by order' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index, params: { order: 'asc' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Get movie' do
    it 'should get movie' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: @movie.id }
      expect(response).to have_http_status(:success)
    end

    it 'should not get movie without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: '' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not get movie with invalid id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Update movie' do
    it 'should update movie' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: @movie.id, title: 'test', image: fixture_file_upload('tree.jpg'),
                               release_date: '2020-01-01',
                               rating: 4, genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:success)
    end

    it 'should not update movie without title' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: @movie.id, title: '', image: fixture_file_upload('tree.jpg'),
                               release_date: '2020-01-01',
                               rating: 5, genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not update movie without release_date' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: @movie.id, title: 'test', image: fixture_file_upload('tree.jpg'),
                               release_date: '', rating: 5, genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not update movie without rating' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: @movie.id, title: 'test', image: fixture_file_upload('tree.jpg'),
                               release_date: '2020-01-01',
                               rating: '', genres: [@genre.name], characters: [@character.name] }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Delete movie' do
    it 'should delete movie' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      delete :destroy, params: { id: @movie.id }
      expect(response).to have_http_status(:success)
    end

    it 'should not delete movie without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      delete :destroy, params: { id: '' }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
