require 'rails_helper'

RSpec.describe "注文フォーム", type: :system do
  let(:name) { '山田太郎' }
  let(:email) {'test@example.com'}
  let(:telephone) { '09012345678' }
  let(:delivery_address) { '東京都千代田区' }
  let(:other_comment) { 'テストコメントです' }

  it '商品を注文できること' do
    visit new_order_path
    
    fill_in 'お名前', with: name
    fill_in 'メールアドレス', with: email
    fill_in '電話番号', with: telephone
    fill_in 'お届け住所', with: delivery_address
    select '銀行振込', from: '支払い方法'

    select '商品A(100円/個)', from: '商品'
    fill_in '数量', with: 3

    fill_in 'その他・ご要望', with: other_comment
    choose '配信を希望する'
    check '検索エンジン'
    check 'SNS'

    click_on '確認画面へ'

    expect(current_path).to eq confirm_orders_path
    click_on 'OK'

    expect(current_path).to eq complete_orders_path
    expect(page).to have_content "#{name}様"

    # 完了ページに再訪すると、入力画面に戻る
    visit complete_orders_path
    expect(current_path).to eq new_order_path

    order = Order.last
    expect(order.name).to eq name
    expect(order.email).to eq email
    expect(order.telephone).to eq telephone
    expect(order.delivery_address).to eq delivery_address
    expect(order.payment_method_id).to eq 2
    expect(order.other_comment).to eq other_comment
    expect(order.direct_mail_enabled).to eq true
    expect(order.inflow_source_ids).to eq [1, 2]
    
    expect(order.order_products.size).to eq 1
    expect(order.order_products[0].product_id).to eq 1
    expect(order.order_products[0].quantity).to eq 3
  end

  context '入力情報に不備があるとき' do
    it '確認画面へ遷移することができない' do
      visit new_order_path
      
      fill_in 'お名前', with: name
      fill_in 'メールアドレス', with: email
      fill_in '電話番号', with: '090123456789'
      fill_in 'お届け住所', with: delivery_address
      select '銀行振込', from: '支払い方法'
      
      select '商品A(100円/個)', from: '商品'
      fill_in '数量', with: 3

      fill_in 'その他・ご要望', with: other_comment
      choose '配信を希望する'
      check '検索エンジン'
      check 'SNS'

      click_on '確認画面へ'
  
      expect(current_path).to eq confirm_orders_path
      expect(page).to have_content '電話番号は11文字以内で入力してください'
    end  

    context '確認画面で戻るボタンを押したとき' do
      it '商品を注文できること' do
        visit new_order_path
        
        fill_in 'お名前', with: name
        fill_in 'メールアドレス', with: email
        fill_in '電話番号', with: telephone
        fill_in 'お届け住所', with: delivery_address
        select '銀行振込', from: '支払い方法'

        select '商品A(100円/個)', from: '商品'
        fill_in '数量', with: 3

        fill_in 'その他・ご要望', with: other_comment
        choose '配信を希望する'
        check '検索エンジン'
        check 'SNS'

        click_on '確認画面へ'
    
        expect(current_path).to eq confirm_orders_path
        
        
        click_on '戻る'
        expect(current_path).to eq orders_path
        expect(page).to have_field('お名前', with: name)
        expect(page).to have_field('メールアドレス', with: email)
        expect(page).to have_field('電話番号', with: telephone)
        expect(page).to have_field('お届け住所', with: delivery_address)
        expect(page).to have_select('支払い方法', selected: '銀行振込')

        expect(page).to have_select('商品', selected: '商品A(100円/個)')
        expect(page).to have_field('数量', with: 3)

        expect(page).to have_field('その他・ご要望', with: other_comment)
        expect(page).to have_checked_field('検索エンジン')
        expect(page).to have_checked_field('SNS')
        expect(page).to have_unchecked_field('友人・知人')

        click_on '確認画面へ'
        expect(current_path).to eq confirm_orders_path
        
        click_on 'OK'
        expect(current_path).to eq complete_orders_path
        expect(page).to have_content "#{name}様"
    
        # 完了ページに再訪すると、入力画面に戻る
        visit complete_orders_path
        expect(current_path).to eq new_order_path
    
        order = Order.last
        expect(order.name).to eq name
        expect(order.email).to eq email
        expect(order.telephone).to eq telephone
        expect(order.delivery_address).to eq delivery_address
        expect(order.payment_method_id).to eq 2
        expect(order.other_comment).to eq other_comment
        expect(order.direct_mail_enabled).to eq true
        expect(order.inflow_source_ids).to eq [1, 2]
        expect(order.order_products.size).to eq 1
        expect(order.order_products[0].product_id).to eq 1
        expect(order.order_products[0].quantity).to eq 3
      end
      
      context '商品を追加して注文した場合' do
        it '商品を注文できること' do
          visit new_order_path
          
          fill_in 'お名前', with: name
          fill_in 'メールアドレス', with: email
          fill_in '電話番号', with: telephone
          fill_in 'お届け住所', with: delivery_address
          select '銀行振込', from: '支払い方法'
      
          select '商品A(100円/個)', from: '商品'
          fill_in '数量', with: 3

          click_on '商品を追加する'
          
          select '商品B(200円/個)', from: 'order[order_products_attributes][1][product_id]'
          fill_in 'order[order_products_attributes][1][quantity]', with: 3

          fill_in 'その他・ご要望', with: other_comment
          choose '配信を希望する'
          check '検索エンジン'
          check 'SNS'
      
          click_on '確認画面へ'
      
          expect(current_path).to eq confirm_orders_path
          click_on 'OK'
      
          expect(current_path).to eq complete_orders_path
          expect(page).to have_content "#{name}様"
      
          # 完了ページに再訪すると、入力画面に戻る
          visit complete_orders_path
          expect(current_path).to eq new_order_path
      
          order = Order.last
          expect(order.name).to eq name
          expect(order.email).to eq email
          expect(order.telephone).to eq telephone
          expect(order.delivery_address).to eq delivery_address
          expect(order.payment_method_id).to eq 2
          expect(order.other_comment).to eq other_comment
          expect(order.direct_mail_enabled).to eq true
          expect(order.inflow_source_ids).to eq [1, 2]
          
          expect(order.order_products.size).to eq 2
          expect(order.order_products[0].product_id).to eq 1
          expect(order.order_products[0].quantity).to eq 3
          expect(order.order_products[1].product_id).to eq 2
          expect(order.order_products[1].quantity).to eq 3
        end
      end
      
      context '商品を追加して、削除して注文した場合' do
        it '商品を注文できること' do
          visit new_order_path
          
          fill_in 'お名前', with: name
          fill_in 'メールアドレス', with: email
          fill_in '電話番号', with: telephone
          fill_in 'お届け住所', with: delivery_address
          select '銀行振込', from: '支払い方法'
      
          select '商品A(100円/個)', from: '商品'
          fill_in '数量', with: 3

          click_on '商品を追加する'
          
          select '商品B(200円/個)', from: 'order[order_products_attributes][1][product_id]'
          fill_in 'order[order_products_attributes][1][quantity]', with: 3

          click_on '削除', match: :first





          fill_in 'その他・ご要望', with: other_comment
          choose '配信を希望する'
          check '検索エンジン'
          check 'SNS'
      
          click_on '確認画面へ'
      
          expect(current_path).to eq confirm_orders_path
          click_on 'OK'
      
          expect(current_path).to eq complete_orders_path
          expect(page).to have_content "#{name}様"
      
          # 完了ページに再訪すると、入力画面に戻る
          visit complete_orders_path
          expect(current_path).to eq new_order_path
      
          order = Order.last
          expect(order.name).to eq name
          expect(order.email).to eq email
          expect(order.telephone).to eq telephone
          expect(order.delivery_address).to eq delivery_address
          expect(order.payment_method_id).to eq 2
          expect(order.other_comment).to eq other_comment
          expect(order.direct_mail_enabled).to eq true
          expect(order.inflow_source_ids).to eq [1, 2]
          
          expect(order.order_products.size).to eq 1
          expect(order.order_products[0].product_id).to eq 2
          expect(order.order_products[0].quantity).to eq 3
        end
      end
    
    end
  end
end
