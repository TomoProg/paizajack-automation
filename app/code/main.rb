require 'bundler'
Bundler.require

# ディーラーの番号
# dealer_name: ディーラーの名前
def dealer_no(dealer_name)
  case dealer_name
    when 'kirishima' then 2             # 霧島 京子
    when 'midorikawa' then 3            # 緑川 つばめ
    when 'rokumura' then 4              # 六村 リオ
    when 'kirishima_buuny' then 5       # 霧島 京子 バニー
    when 'tsubame_bunny' then 6         # 緑川 つばめ バニー
    when 'rokumura_bunny' then 7        # 六村 リオ バニー
    else 1                              # 猫先生
  end
end

# 拡張子からプログラミング言語を選ぶセレクトボックスのテキストを取得する
# filename: ファイル名
def select_box_text(file_name)
  case File.extname(file_name)
    when '.java' then 'Java'
    when '.php' then 'PHP'
    when '.rb' then 'Ruby'
    when '.py2' then 'Python2' # HACK: Python3とPython2の見分けがつかないため、Python2を使う場合はpy2という拡張子を使う
    when '.py' then 'Python3'
    when '.pl' then 'Perl'
    when '.c' then 'C'
    when '.cpp' then 'C++'
    when '.cs' then 'C#' 
    when '.js' then 'JavaScript' 
    when '.m' then 'Objective-C' 
    when '.scala' then 'Scala' 
    when '.go' then 'Go' 
    when '.swift' then 'Swift' 
    when '.hs' then 'Haskell(Beta)' 
    when '.coffee' then 'CoffeeScript(Beta)' 
    when '.sh' then 'Bash(Beta)' 
    when '.erl' then 'Erlang(Beta)' 
    when '.r' then 'R(Beta)' 
    when '.cobol' then 'COBOL(Beta)' 
    when '.vb' then 'VB(Beta)' 
    when '.fs' then 'F#(Beta)' 
    when '.clj' then 'Clojure(Beta)' 
    when '.d' then 'D(Beta)' 
    when '.kt' then 'Kotlin(Beta)' 
    when '.exs', 'ex' then 'Elixir(Beta)' 
    when '.rs' then 'Rust(Beta)' 
    when '.scm' then 'Scheme(Beta)' 
    else raise ArgumentError, "指定されたファイルから言語を推定できません。拡張子を確認してください。指定ファイル[#{file_name}]"
  end
end

# ジャックポットに使うコード
def jackpot_code(file_path, encoding: 'utf-8')
  File.read(file_path, encoding: encoding)
end

# 起動パラメータ確認
code_file_path = ARGV[0]
dealer_name = ARGV[1]

# プログラミング言語確認
program_lang = select_box_text(code_file_path)

driver = Selenium::WebDriver.for(:chrome, url: "http://selenium_server:4444/wd/hub")

# 使用するコードをコピーする
# TODO: paizaのコードエディタに直接入力したい
#       直接入力したいが、オートコンプリートや自動インデントの影響で入力がうまくいかない
driver.manage.timeouts.implicit_wait = 300  # send_key に時間がかかるためタイムアウトを長くしておく
driver.navigate.to "http://onlinememo.net/users/login"
driver.find_element(:id, 'content').send_key(jackpot_code(code_file_path))
#driver.find_element(:id, 'content').set jackpot_code   # undefined method `set' で上手くいかない
driver.find_element(:id, 'content').send_key([:control, 'a'], [:control, 'c'])

# Paizaのジャックポットサイトへ移動
driver.navigate.to "https://paiza.jp/paizajack/" #移動サイト指定
sleep(5)
#puts driver.title

# ログインボタンクリック
# ログイン画面が開くまで待つ
driver.find_element(:id, 'lp_login_btn').click
sleep(5)

# ログインする
driver.find_element(:name, 'user[email]').send_key(ENV['LOGIN_E_MAIL'])
driver.find_element(:name, 'user[password]').send_key(ENV['LOGIN_PASSWORD'])
driver.find_element(:id, 'user_remember').click
driver.find_element(:name, 'commit').click

# 対戦相手選択画面へ移動
driver.navigate.to "https://paiza.jp/paizajack/dealer_release_states/"

# 対戦相手を選ぶ
driver.find_element(:css, ".dealer_select_list#{dealer_no(dealer_name)} .js-load-dealer-select-dialog").click
sleep(5)

# 対戦相手決定
driver.find_element(:css, "#dialog_wrap .float_left").click

# どのプログラミング言語を使うかを決める
select = Selenium::WebDriver::Support::Select.new(driver.find_element(:id, 'js-language_selectbox'))
select.select_by(:text, program_lang)

# エディタにコードを貼り付け
driver.find_element(:class, "ace_text-input").send_keys([:control, 'a'], [:control, 'v'])

# プログラム実行
while true
  driver.find_element(:css, ".program_execution_btn a").click
  driver.switch_to.alert.accept

  start_time = Time.now
  while true
    begin
      driver.find_element(:css, "#page_game_btn .page_game_retry_btn a").click
      break
    rescue Net::ReadTimeout
      if (Time.now - start_time) / 300 >= 1
        raise "タイムアウトが解決されないよ・・・"
      end
      sleep(5)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      # １試合300秒もかからないと思っての300秒
      if (Time.now - start_time) / 300 >= 1
        raise "試合が終わらないよ・・・"
      end
      sleep(5)
    end
  end
end

driver.quit #ブラウザを閉じる
