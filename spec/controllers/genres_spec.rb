require 'rails_helper'

RSpec.describe V1::GenresController, type: :controller do
  before(:all) do
    @user = User.create(name: 'John Doe', email: 'test@test.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG')
    @genre = Genre.create(name: 'Action', image: fixture_file_upload('tree.jpg'))
  end

  after(:all) do
    User.destroy_all
    Genre.destroy_all
  end

  describe 'Create genre' do
    it 'should create genre' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: 'Action', image: fixture_file_upload('tree.jpg') }
      expect(response).to have_http_status(:success)
    end

    it 'should not create genre without name' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: '', image: fixture_file_upload('tree.jpg') }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create genre without image' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: 'Action', image: nil }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Get genres' do
    it 'should get genres' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Get genre' do
    it 'should get genre' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: @genre.id }
      expect(response).to have_http_status(:success)
    end

    it 'should not get genre without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: '' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Update genre' do
    it 'should update genre' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: @genre.id, name: 'Action', image: fixture_file_upload('tree.jpg') }
      expect(response).to have_http_status(:success)
    end

    it 'should not update genre without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: '', name: 'Action', image: fixture_file_upload('tree.jpg') }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Delete genre' do
    it 'should delete genre' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      delete :destroy, params: { id: @genre.id }
      expect(response).to have_http_status(:success)
    end

    it 'should not delete genre without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      delete :destroy, params: { id: '' }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
