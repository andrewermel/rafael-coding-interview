require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe "GET #index" do
    let!(:user) { create(:user) }
    let!(:older_tweet) { create(:tweet, user: user, created_at: 2.days.ago) }
    let!(:newer_tweet) { create(:tweet, user: user, created_at: 1.day.ago) }
    let!(:other_user_tweet) { create(:tweet, created_at: 1.day.ago) } # De outro usuário

    context "when no filters are applied" do
      it "returns tweets sorted by most recent" do
        get :index
        json_response = JSON.parse(response.body)

        expect(json_response["tweets"].count).to eq(3)
        expect(json_response["tweets"].first["id"]).to eq(newer_tweet.id)
      end
    end

    context "when filtering by user" do
      it "returns only the tweets of the specified user" do
        get :index, params: { user_id: user.id }
        json_response = JSON.parse(response.body)

        expect(json_response["tweets"].count).to eq(2)
        expect(json_response["tweets"].map { |t| t["id"] }).to contain_exactly(newer_tweet.id, older_tweet.id)
      end
    end

    context "when using pagination with a cursor" do
      it "returns tweets older than the cursor timestamp" do
        get :index, params: { cursor: newer_tweet.created_at.to_i }
        json_response = JSON.parse(response.body)

        expect(json_response["tweets"].count).to eq(2)
        expect(json_response["tweets"].first["id"]).to eq(older_tweet.id)
      end
    end

    context "when pagination reaches the last tweet" do
      it "returns an empty array and no next_cursor" do
        get :index, params: { cursor: older_tweet.created_at.to_i }
        json_response = JSON.parse(response.body)

        expect(json_response["tweets"]).to be_empty
        expect(json_response["next_cursor"]).to be_nil
      end
    end
  end
end
