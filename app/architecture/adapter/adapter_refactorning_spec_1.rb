require 'rails_helper'

RSpec.describe AdaperUserInfo do
  describe '#to_user' do
    let(api_response) do
      {
        name: "Taro Yamada",
        mail_addres: "taro@example.com"
      }
    end
    let(:adapter) { described_class.new(api_response) }

    it '変換されて希望のレスポンスになっていること' do
      user = adapter.to_user

      expext(user).to be_a(User)
      expect(user[:name]).to eq(user.name)
      expect(user[:mail_address]).to eq(user.email)
    end
  end
end