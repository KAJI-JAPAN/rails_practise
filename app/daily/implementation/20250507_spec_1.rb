'rails_helper'

RSpec.describe "User" do
  describe '#active_users' do
    let!(:active_user) { User.create!(name: "Alice", active: true) }
    let!(:inactive_user) { User.create!(name: "Bob", active: false) }

    it 'activeカラムが true のユーザーだけを返すこと'
    result = User.active_users
    expect(result).to include(active_user)
    expect(result).to not_include(inactive_user)
  end
end