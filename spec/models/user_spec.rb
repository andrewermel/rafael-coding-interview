require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.by_username' do
    let!(:user1) { create(:user, username: 'max') }
    let!(:user2) { create(:user, username: 'mathew') }
    let!(:user3) { create(:user, username: 'john') }

    it 'returns users that match the username partially (case insensitive)' do
      result = User.by_username('ma')
      expect(result).to include(user1, user2)
      expect(result).not_to include(user3)
    end

    it 'returns an empty array if no username matches' do
      result = User.by_username('xyz')
      expect(result).to be_empty
    end
  end
end

