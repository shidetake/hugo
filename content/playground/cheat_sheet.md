+++
date = "2017-03-30T23:30:11+09:00"
draft = false
title = "cheat_sheet"

+++

要約  
チートシート

<!--more-->

かなり癖がある。
恐らく、moreより上に見出し、もしくは小見出しがある場合、
そこまでが要約となり、moreより上にあっても通常の文章は表示されない。
見出しがない場合は、moreより上が全て要約となる。  
バグな気もするが、詳細は不明。

# 見出し
## 小見出し

# 改行
文末に半角スペース2つ  
で改行。

# 脚注
こんな感じ[^a]

[^a]: hoge

# 画像
## from google photo
![image](https://lh3.googleusercontent.com/IrDV2v9sWU8odajHY3Eq6aHccBAlaRC_UKYmddPmc_cg_mxY-2EB5Ud3jvL9djBI74haJHvI-wKsHzfUjDIRNbfbO2a5p6OKRrxA5i8wzJLQJ7OR-uelob5foqV1LWU2FaL76nAco16z_w0lihhyjeSsoQMcvRSmNI4REfVNmasj0MIV5TO5TEA7evE9P-lJMCHRWQIViuQc7SeoZK79NOXlkPSmudl2yCPOGDz8OsPRd4i0oOxAhUZ8F4WPMvKGSbdDk-wl9UjsmwN9UmY_d4E7XRFDXMRId4kEe_BvGi_8j0hHTn9x_f1w0lYKK8g3dwLGw28QDiL0Djp7w_56FshJ5JsIy3fY2iEEVpDdPMzIBdssE3-fk_BvvZ3rO4mRqlnQSGmm1XeaYSTQl-jsUBJG_NsWPjPHO3oNU2wgdP0uQAZ4YW9cik2hmlkTbwuRHoNUvzeWeL9PTpSlI3f7Zu1frVoYkI4co8FmDpKzaaQH2akc40HhL4Pyi06UjXfimRo1DYEIabxEeNiHfY97bGRDVsyf6eX_7WS7Pb0vTtSzaauLCsqVqBd5NRJSoxGtfvbKd9Je56N8ofiSMIc9BqpOCX7PLTc_30t2wTQt_3ZtcugvUEeSpw=w510-h679-no)

![image](https://goo.gl/sWqbQI)

# リンク
## 絶対パス
[Google](http://google.com)  
http://google.com

## 相対パス
[LINE BOTでPUSH通知する](../../misc/line_push/)


# シンタックスハイライト
## ブロック
```ruby
p hello
```

## インライン
文章の途中で`p hello`こんな感じ

## 強調
*強め*
_強め_
**強い**
__強い__

## 箇条書き
- 1段目1
  - 2段目
      - 3段目は3タブ
- 1段目2

## 表
| Left align | Right align | Center align |
|:-----------|------------:|:------------:|
| This       | This        | This         |
| column     | column      | column       |
| will       | will        | will         |
| be         | be          | be           |
| left       | right       | center       |
| aligned    | aligned     | aligned      |

# Category
タグとの使い分けが難しい。イメージ的には、完全に分離できるものがカテゴリーで、重複を許すのがタグ。
例えば、テック系か日常の日記のような記事かはカテゴリーで分ける。
Rubyの話かPythonの話かはタグで分ける。
ソフトかFPGAかは難しいところ。

結局のところ、このブログではテック系の話しかしないので、カテゴリーわけはせずに、タグだけ付ける形がいい気がする。

# Tag
タグは重複を許すので、いくつでもつければ良い。あまり注意はしなくていいが、表記ゆれだけは気をつけたい。
rubyとRubyとか。現時点ではざっくり以下のタグわけ
- Ruby
- LINE BOT
- Raspberry Pi
- Scraping
- Fintech
- Blog
- Smart Home
- API
- Ripping
- Kindle
- Amazon Dash Button

# Amazonアソシエイト
## テキスト
[任意のテキスト](http://amzn.to/2CuC9Qc)

## 画像
小
<a href="https://www.amazon.co.jp/Kindle-Paperwhite-%E9%9B%BB%E5%AD%90%E6%9B%B8%E7%B1%8D%E3%83%AA%E3%83%BC%E3%83%80%E3%83%BC-Wi-Fi-%E3%83%96%E3%83%A9%E3%83%83%E3%82%AF/dp/B00QJDOM6U/ref=as_li_ss_il?ie=UTF8&qid=1518946008&sr=8-2&keywords=kindle&linkCode=li1&tag=shidetake0e-22&linkId=06cf4657a1480646e915ff34bda84373" target="_blank"><img border="0" src="//ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=B00QJDOM6U&Format=_SL110_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=shidetake0e-22" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=shidetake0e-22&l=li1&o=9&a=B00QJDOM6U" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

中
<a href="https://www.amazon.co.jp/Kindle-Paperwhite-%E9%9B%BB%E5%AD%90%E6%9B%B8%E7%B1%8D%E3%83%AA%E3%83%BC%E3%83%80%E3%83%BC-Wi-Fi-%E3%83%96%E3%83%A9%E3%83%83%E3%82%AF/dp/B00QJDOM6U/ref=as_li_ss_il?ie=UTF8&qid=1518946008&sr=8-2&keywords=kindle&linkCode=li2&tag=shidetake0e-22&linkId=0eca241f7fe8e004ca2cb53345f74ef4" target="_blank"><img border="0" src="//ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=B00QJDOM6U&Format=_SL160_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=shidetake0e-22" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=shidetake0e-22&l=li2&o=9&a=B00QJDOM6U" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

大
<a href="https://www.amazon.co.jp/Kindle-Paperwhite-%E9%9B%BB%E5%AD%90%E6%9B%B8%E7%B1%8D%E3%83%AA%E3%83%BC%E3%83%80%E3%83%BC-Wi-Fi-%E3%83%96%E3%83%A9%E3%83%83%E3%82%AF/dp/B00QJDOM6U/ref=as_li_ss_il?ie=UTF8&qid=1518946008&sr=8-2&keywords=kindle&linkCode=li3&tag=shidetake0e-22&linkId=d4b4280270aa00c819d5a99ba50aae18" target="_blank"><img border="0" src="//ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=B00QJDOM6U&Format=_SL250_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=shidetake0e-22" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=shidetake0e-22&l=li3&o=9&a=B00QJDOM6U" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

## テキストと画像
<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="//rcm-fe.amazon-adsystem.com/e/cm?lt1=_blank&bc1=000000&IS2=1&bg1=FFFFFF&fc1=000000&lc1=0000FF&t=shidetake0e-22&o=9&p=8&l=as4&m=amazon&f=ifr&ref=as_ss_li_til&asins=B00QJDOM6U&linkId=05fa0e9ef8fc667966c6780e891940c1"></iframe>
