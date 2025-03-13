require 'rails_helper'

RSpec.describe "Users", type: :request do
  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times { create(:user, company: company_1) }
      5.times { create(:user, company: company_2) }
    end
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }

    context 'when fetching users by company' do
      include_context 'with multiple companies'

      it 'returns only the users for the specified company' do
        get users_path, params: { company_identifier: company_1.id }

        
        expected_size = company_1.users.reload.size
        returned_size = result.size
        returned_ids = result.map { |element| element['id'] }
        
        puts "Esperado: #{expected_size}, Retornado: #{returned_size}"
        puts "IDs esperados: #{company_1.users.ids}, IDs retornados: #{returned_ids}"
        
        expect(returned_size).to eq(expected_size)
        expect(returned_ids).to match_array(company_1.users.ids)
      end
    end

    context 'when fetching all users' do
      include_context 'with multiple companies'

      it 'returns all the users' do
        get users_path
        
        expected_size = User.count
        returned_size = result.size
        
        puts "Esperado: #{expected_size}, Retornado: #{returned_size}"
        
        expect(returned_size).to eq(expected_size)
      end
    end
  end
end