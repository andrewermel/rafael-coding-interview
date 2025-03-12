require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    let!(:company) { create(:company) }
    let!(:user1) { create(:user, username: "max", company: company) }
    let!(:user2) { create(:user, username: "mathew", company: company) }
    let!(:user3) { create(:user, username: "john", company: create(:company)) } # Outro company

    context "when filtering by company" do
      it "returns users only from the specified company" do
        get :index, params: { company_identifier: company.id }
        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq(2)
        expect(json_response.map { |u| u["username"] }).to contain_exactly("max", "mathew")
      end
    end

    context "when filtering by partial username" do
      it "returns users whose username includes the search term" do
        get :index, params: { username: "ma" }
        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq(2)
        expect(json_response.map { |u| u["username"] }).to contain_exactly("max", "mathew")
      end
    end

    context "when filtering by company and username" do
      it "returns only users matching both filters" do
        get :index, params: { company_identifier: company.id, username: "max" }
        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq(1)
        expect(json_response.first["username"]).to eq("max")
      end
    end

    context "when no filters are applied" do
      it "returns all users" do
        get :index
        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq(3)
      end
    end
  end
end
