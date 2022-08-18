require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  before(:all) do
    @user = User.create(name: 'John Doe', email: 'test@test.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG')
  end

  after(:all) do
    User.destroy_all
  end

  context 'User authentication' do
    it 'should authenticate user' do
      post :authenticate, params: { email: @user.email, password: '121212' }
      expect(response).to have_http_status(:success)
    end

    it 'should not authenticate user' do
      post :authenticate, params: { email: @user.email, password: '12121212' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'User registration' do
    it 'should register user' do
      post :add, params: { name: 'John Doe', email: 'test2@test.com', password: '121212' }
      expect(response).to have_http_status(:success)
    end

    it 'should not register user with existing email' do
      post :add, params: { name: 'John Doe', email: 'test@test.com', password: '121212' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'Should get bad request name cannot be blank' do
      post :add, params: { name: '', email: 'test2@test.com', password: '121212' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'Should get bad request email cannot be blank' do
      post :add, params: { name: 'John Doe', email: '', password: '121212' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'Should get bad request password cannot be blank' do
      post :add, params: { name: 'John Doe', email: 'test2@test.com', password: '' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'Should get bad request password must be at least 6 characters' do
      post :add, params: { name: 'John Doe', email: 'test2@test.com', password: '1212' }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
