require 'rails_helper'

RSpec.describe Character, type: :model do
  describe 'validations' do
    after(:each) do
      Character.destroy_all
    end

    it 'is valid with valid attributes' do
      subject = Character.new(name: 'Test', age: 20, weight: 50, history: 'blablabla',
                              image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject = Character.new(name: nil, age: 20, weight: 50, history: 'blablabla',
                              image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without an age' do
      subject = Character.new(name: 'Test', age: nil, weight: 50, history: 'blablabla',
                              image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without a weight' do
      subject = Character.new(name: 'Test', age: 20, weight: nil, history: 'blablabla',
                              image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without a history' do
      subject = Character.new(name: 'Test', age: 20, weight: 50, history: nil,
                              image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without an image' do
      subject = Character.new(name: 'Test', age: 20, weight: 50, history: 'blablabla',
                              image: nil)
      subject.save
      expect(subject).to_not be_valid
    end
  end
end
