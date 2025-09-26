module SystemHelpers
  def basic_auth_visit(path)
    username = ENV['BASIC_AUTH_USER']
    password = ENV['BASIC_AUTH_PASSWORD']
    visit "http://#{username}:#{password}@#{Capybara.server_host}:#{Capybara.server_port}#{path}"
  end

  def login_as(user)
    basic_auth_visit(new_user_session_path)
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  def logout
    click_button 'ログアウト'
  end
end
