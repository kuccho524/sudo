require 'rails_helper'

describe '管理者のテスト' do
  describe '管理者ログイン前のテスト' do
    let(:admin) { create(:admin) }

    before do
      visit new_admin_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'admin[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'admin[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'admin[email]', with: admin.email
        fill_in 'admin[password]', with: admin.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインした管理者のトップ画面になっている' do
        expect(current_path).to eq '/admin/homes/top'
      end
    end
  end

  describe 'ログイン後のテスト' do
    let(:admin) { create(:admin) }

    before do
      visit new_user_session_path
      fill_in 'admin[email]', with: admin.name
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
    end

    context '商品一覧画面の表示' do
      it 'ジャンル一覧リンクが存在する' do
        expect(page).to have_link '', href: admin_genres_path
      end
      it '商品一覧画面に新規投稿ボタンのリンクが存在する' do
        expect(page).to have_link '', href: new_admin_product_path
      end
      it '商品一覧画面に登録した商品が表示される' do
        expect(page).to have_content product.id
      end
      it '商品名が表示される' do
        expect(page).to have_content product.name
      end
      it '商品のリンク先が正しい' do
        expect(page).to have_link '', href: admin_product_path(product.id)
      end
      it '税抜価格が表示される' do
        expect(page).to have_content product.price
      end
      it 'ジャンルが表示される' do
        expect(page).to have_content product.genre.name
      end
      it '販売ステータスが表示される' do
        expect(page).to have_content product.sales_status
      end
    end
  end

  describe '商品新規投稿画面のテスト' do
    before do
      visit new_admin_product_path
    end

    context '商品新規投稿画面' do
      before do
        fill_in 'product[image_id]'
        fill_in 'product[name]'
        fill_in 'product[introduction]'
        fill_in 'product[genre_id]'
        fill_in 'product[proce]'
        fill_in 'product[sales_status]'
      end
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '新規登録' }.to change(products, :count).by(1)
      end
      it 'リダイレクト先が、保存できた商品の詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/admin/products/' + Product.last.id.to_s
      end
    end
  end

  describe '商品詳細画面のテスト' do
    before do
      visit admin_product_path(product.id)
    end

    context '商品詳細画面' do
      it '商品一覧リンクが存在する' do
        expect(page).to have_link '', href: admin_products_path
      end
    end
  end

  describe '商品一覧画面のテスト(2回目)' do
    before do
      visit admin_top_path
    end

    context '商品一覧画面の表示' do
      it '商品一覧画面に登録した商品が表示される' do
        expect(page).to have_content product.id
      end
      it '商品一覧画面に新規投稿ボタンのリンクが存在する' do
        expect(page).to have_link '', href: new_admin_product_path
      end
    end
  end

  describe '商品新規投稿画面のテスト(2回目)' do
    before do
      visit new_admin_product_path
    end

    context '商品新規投稿画面' do
      before do
        fill_in 'product[image_id]'
        fill_in 'product[name]'
        fill_in 'product[introduction]'
        fill_in 'product[genre_id]'
        fill_in 'product[proce]'
        fill_in 'product[sales_status]'
      end
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '新規登録' }.to change(products, :count).by(1)
      end
      it 'リダイレクト先が、保存できた商品の詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/admin/products/' + Product.last.id.to_s
      end
    end
  end

  describe '商品一覧画面のテスト(3回目)' do
    before do
      visit admin_top_path
    end

    context '商品一覧画面の表示' do
      it '商品一覧画面に登録した商品が表示される' do
        expect(page).to have_content product.id
      end
      it 'ログアウトのリンクが存在する' do
        expect(page).to have_link '', href: destroy_admin_session_path
      end
      it 'ログアウトすると、ログイン画面にリダイレクトされる' do
        click_button 'ログアウト'
        expect(current_path).to eq '/admin/sign_in'
      end
    end
  end
end