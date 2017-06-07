+++
categories = []
date = "2017-06-04T22:44:34+09:00"
draft = false
tags = []
thumbnail = ""
title = "KindleのハイライトをLINEに通知する 2"

+++

[前回](../line_highlights_1/)はクローラーを作成してハイライトを取得するところまでだった。
今回はサーバで起動してLINE通知するところまでを作る。

## サーバで起動
前回はSeleniumを使ったが、サーバで実行する場合はGUIアプリケーションにはできないので、
POLTERGEISTを使う。

```diff
  def initialize
-   Capybara.current_driver = :selenium
+   Capybara.current_driver = :poltergeist
-   Capybara.javascript_driver = :selenium
+   Capybara.javascript_driver = :poltergeist
    Capybara.app_host = 'https://kindle.amazon.co.jp'
    Capybara.default_max_wait_time = 5
-   Capybara.register_driver :selenium do |app|
+   Capybara.register_driver :poltergeist do |app|
-     # 最新のSeleniumではFirefoxが動作しない問題があるのでchromeを使う
-     Capybara::Selenium::Driver.new(app, :browser => :chrome)
+     Capybara::Poltergeist::Driver.new(app, {:timeout => 120, js_errors: false})
    end
+   page.driver.headers = {'User-Agent' => 'Mac Safari'}
  end
```

Amazonのウェブサイト固有の問題で、ユーザーエージェントの変更が必要なので、Mac Safariとしている。

これでサーバ（今回はUbuntuを使った）で動作するようになった。


## LINE通知
line-bot-apiを使った。だいたい以下のような感じ。Channel Secret, Channel Access Token, userIdはLINE developersから取得して入力すること。
push_highlightメソッドを使って、前回標準出力していた文字列をLINEに送れる。

```diff
  def initialize(driver)
    Capybara.current_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.app_host = 'https://kindle.amazon.co.jp'
    Capybara.default_max_wait_time = 5
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:timeout => 120, js_errors: false})
    end
    page.driver.headers = {'User-Agent' => 'Mac Safari'} if driver == POLTERGEIST

+   @line = Line::Bot::Client.new do |config|
+     config.channel_secret = ''
+     config.channel_token  = ''
+   end

+   @user_id = ''
  end

+ def push_highlight(highlight)
+   message = {
+     type: 'text',
+     text: highlight
+   }

+   @line.push_message(@user_id, message)
+ end
```

[続きはこちら](../line_highlights_3/)
