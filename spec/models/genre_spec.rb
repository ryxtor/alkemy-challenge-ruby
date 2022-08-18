require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'validations' do
    after { Genre.destroy_all }

    it 'is valid with valid attributes' do
      subject = Genre.new(name: 'Test', image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject = Genre.new(name: nil, image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid with a name with more than 20 characters' do
      subject = Genre.new(name: 'a' * 21, image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without an image' do
      subject = Genre.new(name: 'Test', image: nil)
      subject.save
      expect(subject).to_not be_valid
    end
  end
end
