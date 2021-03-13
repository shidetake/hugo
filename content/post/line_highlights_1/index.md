+++
categories = ["Tech"]
date = "2017-05-27T13:08:32+09:00"
tags = ["Kindle","LINE BOT","Scraping","Ruby"]
title = "KindleのハイライトをLINEに通知する 1"

+++

読書メモのためにハイライトした文章をコピペできる形にしたい。
KindleにはハイライトをメールやTwitterでシェアする機能があるが、これはアクションが増えて読書を妨げるので使いたくない。

ハイライトした内容は https://kindle.amazon.co.jp/your_highlights で見えるので、これを取得して通知するクローラーを作ればよい。

<!--more-->

## クローラー作成
RubyのCapybaraを使った。

### 動作環境
```bash
ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-darwin15]
selenium-webdriver (2.53.0, 2.52.0)
capybara (2.14.0)
```

### ソースコード
```ruby
# coding: utf-8
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'selenium-webdriver'

class LineKindleHighlights
  include Capybara::DSL

  KINDLE_EMAIL    = 'your@email'
  KINDLE_PASSWORD = 'your_password'
  CRAWL_PAGE_NUM = 2

  def initialize
    Capybara.current_driver = :selenium
    Capybara.javascript_driver = :selenium
    Capybara.app_host = 'https://kindle.amazon.co.jp'
    Capybara.default_max_wait_time = 5
    Capybara.register_driver :selenium do |app|
      # 最新のSeleniumではFirefoxが動作しない問題があるのでchromeを使う
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
  end

  def scrape
    login

    # ページ読み込み待ち
    sleep 5

    go_to_highlights

    CRAWL_PAGE_NUM.times do
      all('.title').each do |element|
        p element.text
      end

      all('.highlight').each do |element|
        p element.text
      end

      next_page
    end
  end

  private

  # Kindleのマイページにアクセスしログインする
  def login
    visit('')
    click_link 'sign in'
    fill_in 'ap_email',
      :with => KINDLE_EMAIL
    fill_in 'password',
      :with => KINDLE_PASSWORD
    click_on 'signInSubmit'
  end

  # Your Hightlightsのページに遷移する
  # @note ログイン直後のページで使う
  def go_to_highlights
    click_link 'Your Highlights'
  end

  # 次のページに遷移
  # @note Your Hightlightsのページで使うことで次の本のハイライトページに遷移する
  def next_page
    visit(find_by_id('nextBookLink', visible: false)[:href])
  end
end

crawler = LineKindleHighlights.new
crawler.scrape
```

- `KINDLE_EMAIL`と`KINDLE_PASSWORD`だけ設定すれば動く
- `CRAWL_PAGE_NUM`は実質的には取得するハイライトの本の数になる (1ページに1冊分の情報が出る）
- 次のページへの遷移で少しハマった。hiddenなクラスのリンクを取得するには`visible: false`する必要があるらしい

とりあえず今回はここまで。

[続きはこちら](../line_highlights_2/)

## TODO
- [x] クローラー作成
- [ ] LINE通知機能
- [ ] 通知済みハイライトを通知しない
- [ ] サーバ上で動作
