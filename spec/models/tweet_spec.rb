require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe "associations" do
    it "belongs to a user" do
      company = create(:company)  # Criamos uma empresa
      user = create(:user, company: company)  # Criamos um usuário associado à empresa
      tweet = Tweet.create!(user: user, body: "Meu primeiro tweet")

      expect(tweet.user).to eq(user)
    end
  end

  describe 'validations' do
    it 'is valid with a user' do
      user = create(:user)
      tweet = build(:tweet, user: user)
      expect(tweet).to be_valid
    end

    it 'is invalid without a user' do
      tweet = build(:tweet, user: nil)
      expect(tweet).not_to be_valid
    end
  end
end
