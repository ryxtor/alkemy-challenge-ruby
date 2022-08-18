require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { User.new(name: 'John Doe', email: 'test@test.com', password: '123456') }
    before { subject.save }
    after { User.destroy_all }

    it 'Should be valid' do
      expect(subject).to be_valid
    end

    it 'Should not be valid without name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'Should not be valid with a name with more than 20 characters' do
      subject.name = 'a' * 21
      expect(subject).to_not be_valid
    end

    it 'Should not be valid without email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'Should not be valid with a wrong email format' do
      subject.email = 'testtest.com'
      expect(subject).to_not be_valid
    end

    it 'Should not be valid without password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it 'Should not be valid with a password with less than 6 characters' do
      subject.password = '12345'
      expect(subject).to_not be_valid
    end
  end
end
