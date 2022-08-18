require 'rails_helper'

RSpec.describe V1::CharactersController, type: :controller do
  before(:all) do
    @user = User.create(name: 'John Doe', email: 'test@test.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG')
    @character = Character.create(name: 'test', age: 30, weight: 80, history: 'History',
                                  image: fixture_file_upload('tree.jpg'))
  end

  after(:all) do
    User.destroy_all
    Character.destroy_all
  end

  describe 'Create character' do
    it 'should create character' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: 'John Doe', image: fixture_file_upload('tree.jpg'), history: 'History', age: 25,
                              weight: 75 }
      expect(response).to have_http_status(:success)
    end

    it 'should not create character without name' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: '', image: fixture_file_upload('tree.jpg'), history: 'History', age: 25,
                              weight: 75 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create character without image' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: 'John Doe', image: nil, history: 'History', age: 25,
                              weight: 75 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create character without history' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: 'John Doe', image: fixture_file_upload('tree.jpg'), history: '', age: 25,
                              weight: 75 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create character without age' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: 'John Doe', image: fixture_file_upload('tree.jpg'), history: 'History', age: '',
                              weight: 75 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not create character without weight' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: { name: 'John Doe', image: fixture_file_upload('tree.jpg'), history: 'History', age: 25,
                              weight: '' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Get characters' do
    it 'should get characters' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should get characters by name' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index, params: { name: 'test' }
      expect(response).to have_http_status(:success)
    end

    it 'should get characters by age' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :index, params: { age: 30 }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Get character' do
    it 'should get character' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: @character.id }
      expect(response).to have_http_status(:success)
    end

    it 'should not get character without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: '' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not get character with invalid id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Update character' do
    it 'should update character' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: @character.id, name: 'John Doe', image: fixture_file_upload('tree.jpg'),
                               history: 'History', age: 25, weight: 75 }
      expect(response).to have_http_status(:success)
    end

    it 'should not update character without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: '', name: 'John Doe', image: fixture_file_upload('tree.jpg'),
                               history: 'History', age: 25, weight: 75 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should not update character with invalid id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      patch :update, params: { id: 'invalid', name: 'John Doe', image: fixture_file_upload('tree.jpg'),
                               history: 'History', age: 25, weight: 75 }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Delete character' do
    it 'should delete character' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      delete :destroy, params: { id: @character.id }
      expect(response).to have_http_status(:success)
    end

    it 'should not delete character without id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      delete :destroy, params: { id: '' }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
