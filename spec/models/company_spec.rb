require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "associations" do
    it "has many users" do
      company = Company.create!(name: "Empresa Teste")
      user1 = User.create!(username: "user1", email: "user1@example.com", company: company)
      user2 = User.create!(username: "user2", email: "user2@example.com", company: company)

      expect(company.users).to include(user1, user2)
      expect(company.users.count).to eq(2)
    end
  end

  describe "validations" do
    it "is valid with a name" do
      company = Company.new(name: "Empresa Teste")
      expect(company).to be_valid
    end

    it "is invalid without a name" do
      company = Company.new(name: nil)
      expect(company).not_to be_valid
    end
  end
end
