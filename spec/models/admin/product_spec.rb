require 'rails_helper'

RSpec.describe 'Productモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { product.valid? }

    let(:admin) { create(:admin) }
    let!(:product) { build(:product, admin_id: admin.id) }

    context 'nameカラム' do
      it '空欄でないこと' do
        product.name = ''
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '空欄でないこと' do
        product.introduction = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Genreモデルとの関係' do
      it 'N:1となっている' do
        expect(Product.reflect_on_association(:genre).macro).to eq :belongs_to
      end
    end
  end
end