require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'validations' do
    after { Movie.destroy_all }

    it 'is valid with valid attributes' do
      subject = Movie.new(title: 'Test', release_date: '2000-05-02', rating: 4, image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to be_valid
    end

    it 'is not valid without a title' do
      subject = Movie.new(title: nil, release_date: '2000-05-02', rating: 4, image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid with a title with more than 50 characters' do
      subject = Movie.new(title: 'a' * 51, release_date: '2000-05-02', rating: 4,
                          image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without a release date' do
      subject = Movie.new(title: 'Test', release_date: nil, rating: 4, image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without a rating' do
      subject = Movie.new(title: 'Test', release_date: '2000-05-02', rating: nil,
                          image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid with a rating less than 0' do
      subject = Movie.new(title: 'Test', release_date: '2000-05-02', rating: -1, image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid with a rating greater than 5' do
      subject = Movie.new(title: 'Test', release_date: '2000-05-02', rating: 6, image: fixture_file_upload('tree.jpg'))
      subject.save
      expect(subject).to_not be_valid
    end

    it 'is not valid without an image' do
      subject = Movie.new(title: 'Test', release_date: '2000-05-02', rating: 4, image: nil)
      subject.save
      expect(subject).to_not be_valid
    end
  end
end
