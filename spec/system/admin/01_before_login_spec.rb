require 'rails_helper'

describe '[STEP1] 管理者ログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ログインリンクが表示される: 左上から5番目のリンクが「ログイン」である' do
        log_in_link = find_all('a')[5].native.inner_text
        expect(log_in_link).to match(/log in/i)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[5].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it '新規登録リンクが表示される: 左上から4番目のリンクが「新規登録」である' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(sign_up_link).to match(/sign up/i)
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Bookers'
      end
      it 'Homeリンクが表示される: 左上から1番目のリンクが「Home」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/home/i)
      end
      it 'Aboutリンクが表示される: 左上から2番目のリンクが「About」である' do
        about_link = find_all('a')[2].native.inner_text
        expect(about_link).to match(/about/i)
      end
      it 'sign upリンクが表示される: 左上から3番目のリンクが「新規登録」である' do
        signup_link = find_all('a')[3].native.inner_text
        expect(signup_link).to match(/sign up/i)
      end
      it 'loginリンクが表示される: 左上から4番目のリンクが「ログイン」である' do
        login_link = find_all('a')[4].native.inner_text
        expect(login_link).to match(/login/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'LOGO画像を押すと、トップ画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it '商品一覧を押すと、商品一覧画面に遷移する' do
        products_link = find_all('a')[3].native.inner_text
        products_link = products_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link products_link
        is_expected.to eq '/products'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[4].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/customers/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[5].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/customers/sign_in'
      end
    end
  end

  describe '管理者ログイン' do
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

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:admin) { create(:admin) }

    before do
      visit new_user_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'Log in'
    end

    context 'ヘッダーの表示を確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'LOGO'
      end
      it 'Homeリンクが表示される: 左上から1番目のリンクが「Home」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/home/i)
      end
      it '商品一覧リンクが表示される: 左上から2番目のリンクが「商品一覧」である' do
        products_link = find_all('a')[2].native.inner_text
        expect(products_link).to match(/products/i)
      end
      it '顧客一覧リンクが表示される: 左上から3番目のリンクが「顧客一覧」である' do
        customers_link = find_all('a')[3].native.inner_text
        expect(customers_link).to match(/customers/i)
      end
      it '注文履歴一覧リンクが表示される: 左上から3番目のリンクが「注文履歴一覧」である' do
        orders_link = find_all('a')[4].native.inner_text
        expect(orders_link).to match(/orders/i)
      end
      it 'ジャンル一覧リンクが表示される: 左上から3番目のリンクが「ジャンル一覧」である' do
        genres_link = find_all('a')[5].native.inner_text
        expect(genres_link).to match(/genres/i)
      end
      it 'ログアウトリンクが表示される: 左上から4番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[6].native.inner_text
        expect(logout_link).to match(/logout/i)
      end
    end
  end
end
