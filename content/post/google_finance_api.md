+++
categories = ["category","subcategory"]
date = "2017-09-04 23:14:36"
keywords = ["tech"]
tags = ["tag1","tag2"]
title = "Google Finance APIを使って株価チャートを作成"

+++

株を買うかどうか判断するために株価チャートに補助線を書いたりする手法があるらしい。
手軽に補助線（トレンドラインと呼ぶらしい）を引いてくれるスクリプトでも作ろうかと思い、
まずは普通の株価チャートを描いてみた。

そのへんに落ちてるアプリでもできそうだけど、最終的に買いかどうか判断させたり、
色々自由にカスタマイズするには自分で作ったほうがいいかなと。

<!--more-->

2017.9.16追記  
これを公開した直後にAPIのURLが変わった模様。

元は`https://www.google.com/finance/getprices?`だったが、今は`https://finance.google.com/finance/getprices?`になっている。
この記事のコードも修正したので、そのまま使えるはず。


## Google Finance API
国内で株価を取得するためのAPIは（正規には）ないらしい。
ただ、Google Finance APIという非公式のAPIがあり、使ってる人は使っているとか。

[google financeのAPIのメモ](http://ymtttk.hatenablog.jp/entry/2017/02/18/192130)という記事が参考になる。
今回やりたいことのほとんどはここに書いてある。
違いは、

- Rubyを使う (Pythonのが需要ありそうだけど) 
- チャートを描く

くらい。

まずは適当な銘柄の株価を以下のように取得する。
ここではトヨタにした（丸パクリ）。

```ruby
require 'net/http'

class GoogleFinance

  BASE_URL = 'https://finance.google.com/finance/getprices?'

  def initialize(issue)
    @issue = issue
  end

  def stock(period = '1Y', interval_sec = 86400)
    raw_data = Net::HTTP.get(URI.parse(BASE_URL + "p=#{period}&i=#{interval_sec}&x=TYO&q=#{@issue}"))
    data = []
    raw_data.lines do |line|
      data << line[/^[0-9]*,([0-9]*)/, 1]
    end
    data.compact
  end
end

google_finance = GoogleFinance.new(7203)
stock_data = google_finance.stock
```

取得したデータを1行ずつ取ってきて、`/^[0-9]*,([0-9]*)/, 1`という正規表現で終値を抜き出している。
先頭に数値があり、カンマ挟んで次の数値を取得するという意味。

これを配列に突っ込んで、先頭の方にあるゴミ（抽出条件などが書かれている）をcompactで取り除くことで、
この1年間のトヨタ株の終値の配列が完成。


## チャート描画
これはgnuplotを使う。
[Numo::Gnuplot](https://github.com/ruby-numo/gnuplot)というgemが便利そうだったので、これを使った。

```bash
gem install numo-gnuplot
```

してから、
（当然、gnuplotも入れる）

```ruby
require 'net/http'
require 'numo/gnuplot'

class GoogleFinance
  # 省略
end

google_finance = GoogleFinance.new(7203)
stock_data = google_finance.stock

Numo.gnuplot do
  set title:'TOYOTA'
  plot stock_data, w:'lines'
end
```

これだけ。GoogleFinanceクラスは変わらないので省略した。
得られたチャートを貼って終わり。

![image](http://ift.tt/2wAIcS7)
