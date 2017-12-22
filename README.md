# paizajack-automation
一攫千金プログラミング〜ポットdeジャックポット〜 の自動化ツールです。

### 必要なミドルウェア
この自動化ツールは以下のミドルウェアを使うことを前提としています。
- docker
- docker-compose

`docker`および`docker-compose`をインストールしていない場合は  
[こちら](https://docs.docker.com/compose/install/)のドキュメントを参考にインストールしてください。

### 使い方
#### 1. ログイン情報の設定  
まずは`Paiza`へのログインのための、メールアドレスとパスワードを設定します。  
メールアドレスとパスワードは`docker-compose.yml`で環境変数として定義してあります。  
`LOGIN_E_MAIL`と`LOGIN_PASSWORD`の項目を自分が使っているメールアドレスとパスワードに書き換えてください。  
```
# docker-compose.yml
environment:
  LOGIN_E_MAIL: sample@gmail.com # ここを書き換える
  LOGIN_PASSWORD: sample 　　　　　　　　　　　　　　　　# ここを書き換える
```

#### 2. コンテナの起動  
ログイン情報の設定を終えたら、コンテナを立ち上げます。
```
$ cd paizajack-automation
$ docker-compose up
```

コンテナが立ち上がったらVNCでSeleniumコンテナで起動しているサーバに接続します。  
Macであれば`Finder`を立ち上げて、`Command + k`で`vnc://localhost:5900`に接続してください。  
パスワードは`secret`です。  

以下のような画面が立ち上がってくれば、起動できています。  
![Seleniumトップページ](https://github.com/TomoProg/image-repo/blob/master/paizajack-automation/selenium-top.png "サンプル")

#### 3. 実行  
あとは、スクリプトを起動します。
dockerコンテナ内でスクリプトを起動したい場合は
```
$ docker exec -it paiza /bin/bash
# ruby code/main.rb program_lang dealer_name
```

ターミナルから直接起動したい場合は
```
$ docker exec -it paiza ruby code/main.rb program_lang dealer_name
```

スクリプトの起動引数は以下の通りです。
- program_lang  
使用するプログラミング言語を指定します。  
プログラム記述画面のセレクトボックスの値です。  

- dealer_name  
対戦するディーラーの名前を指定します。  
`main.rb`の`dealer_no`メソッドに書かれている名前を使用してください。  

例えばプログラミング言語にRubyを使って、霧島　京子と戦いたい場合は以下のコマンドで対戦できます。
```
# ruby code/main.rb Ruby kirishima
or
$ docker exec -it paiza ruby code/main.rb Ruby kirishima
```

完成途中のため、この仕様は変更されることもあります。（笑）
