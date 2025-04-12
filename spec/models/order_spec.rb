require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#total_price' do
    let(:params) do
      {
        order_products_attributes: [
          { product_id: 1, quantity: 3 },
          { product_id: 2, quantity: 2 }
        ]
      }
    end

    subject { Order.new(params).total_price }

    it { is_expected.to eq 700 + 70 }

    context '消費税に端数が出た場合' do
      before do
        create(:product, id: 99, price: 299)
      end

      let(:params) do
        {
          order_products_attributes: [
            { product_id: 99, quantity: 1 }
            ]
        }
      end

      # 値段299円のものを1個買った場合 消費税29.9円 切り上げ = 30円
      it { is_expected.to eq 329 }
    end
  end

  describe '#valid?' do
    let(:name) { '山田太郎' }
    let(:email) {'test@example.com'}
    let(:telephone) { '09012345678' }
    let(:delivery_address) { '東京都千代田区' }
    let(:payment_method_id) { 1 }
    let(:other_comment) { '特になし' }
    let(:direct_mail_enabled) { true }
    let(:params) do
      {
        name: name,
        email: email,
        telephone: telephone,
        delivery_address: delivery_address,
        payment_method_id: payment_method_id,
        other_comment: other_comment,
        direct_mail_enabled: direct_mail_enabled
      }
    end

    subject { Order.new(params).valid? }

    it { is_expected.to eq true }

    context '名前が空の場合' do
      let (:name) { '' }

      it { is_expected.to eq false}
    end

    context 'メールアドレスが空の場合' do
      let (:email) { '' }

      it { is_expected.to eq false}
    end

    context 'メールアドレスの書式が正しくない場合' do
      let (:email) { 'testexample.com' }

      it { is_expected.to eq false}
    end

    context 'メールアドレスが全角の場合' do
      let (:email) { 'ｓａｍｐｌｅ@example.com' }

      it { is_expected.to eq true}
    end

    context '電話番号が空の場合' do
      let (:telephone) { '' }

      it { is_expected.to eq false}
    end

    context '電話番号が全角の場合' do
      let (:telephone) { '０９０５５５５５５５５' }

      it { is_expected.to eq true }
    end

    context '電話番号に数字以外が含まれている場合' do
      let (:telephone) { '090-4444-4444' }

      it { is_expected.to eq true }
    end

    context '電話番号が１２桁の場合' do
      let (:telephone) { '090999999999' }

      it { is_expected.to eq false }
    end

    context 'お届け先住所が空の場合' do
      let (:delivery_address) { '' }

      it { is_expected.to eq false}
    end
    
    context '支払い方法が未入力の場合' do
      let (:payment_method_id) { nil }

      it { is_expected.to eq false}
    end

    context 'その他・ご要望が空の場合' do
      let (:other_comment) { '' }

      it { is_expected.to eq true}
    end
    
    context 'その他・ご要望が1000文字の場合' do
      let (:other_comment) { 'あ' * 1_000 }

      it { is_expected.to eq true}
    end

    context 'その他・ご要望が1001文字の場合' do
      let (:other_comment) { 'あ' * 1_001 }

      it { is_expected.to eq false}
    end

    context 'メールマガジンの配信要否が未選択の場合' do
      let (:direct_mail_enabled) { nil }

      it { is_expected.to eq false}
    end
  end
end
