require 'bundler'
Bundler.require

driver = Selenium::WebDriver.for(:chrome, url: "http://selenium_server:4444/wd/hub")

# Paizaのジャックポットサイトへ移動
driver.navigate.to "https://paiza.jp/paizajack/" #移動サイト指定
#sleep(5)
#puts driver.title

# ログインボタンクリック
driver.find_element(:id, 'lp_login_btn').click

# ログイン画面が開くまで待つ
sleep(10)

# ログインする
driver.find_element(:name, 'user[email]').send_key(ENV['LOGIN_E_MAIL'])
driver.find_element(:name, 'user[password]').send_key(ENV['LOGIN_PASSWORD'])
driver.find_element(:id, 'user_remember').click
driver.find_element(:name, 'commit').click

# 対戦相手選択
driver.navigate.to "https://paiza.jp/paizajack/dealer_release_states/"

# 対戦相手選択
sleep(5)

driver.quit #ブラウザを閉じる
