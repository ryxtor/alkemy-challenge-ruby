class User < ApplicationRecord
  before_create :generate_token
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  private

  def generate_token
    self.token = JwtHelper::JsonWebToken.encode(email)
  end
end
