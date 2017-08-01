+++
categories = ["category","subcategory"]
date = "2017-07-30 22:56:40"
keywords = ["tech"]
tags = ["tag1","tag2"]
title = "Picasa APIを使ってGoogle Photoからデジカメ写真だけを取得 1"

+++

Google Photoの検索では、Exif情報の撮影機器のモデル名をキーにすることができないらしい。
あるデジカメで撮った写真だけを抽出するために試行錯誤した結果、
PicasaのAPIを使うことで実現できたので、そのやり方を記す。
<!--more-->

ちなみにGoogle PhotoのAPIはまだ用意されておらず、Piacasa APIがその代替となっている。

# Picasa APIを使う
## Access tokenの取得
[Gmailのとき](../gmail_api_1/)とは違い、PicasaのAPIを使うのは少しコツがいる。
既にPicasaのサービスが終了しているためか、API MANAGERで検索してもPicasa APIが出てこない。

そこで、Access tokenを取得するために[OAuth 2.0 Playground](https://developers.google.com/oauthplayground/)を使う。

Select the scopeの一覧から、Picasa Web v2を選択して表示されるURLをクリックする。
Authorize APIsボタンが有効になるので、それを押してAPIを有効にする許可を与える。

Authorization codeが取得できるので、続けてExchange authorization code for tokensボタンを押下。
これでAccess tokenが得られる。

## Access tokenの確認
得られたAccess tokenの確認も兼ねて、簡単なAPIを使ってみる。

まずはRubyでPicasa APIを簡単に使えるようにするgemをインストール。

```bash
gem install picasa
```

あとは以下のようなスクリプトでアルバム名の一覧を取得する。

```ruby
require 'picasa'

client = Picasa::Client.new(
  user_id: 'your@email',
  access_token: 'your_access_token'
)

albums = client.album.list.entries
albums.each { |a| p a.title }
```

your@emailとyour_access_tokenにはそれぞれ自分の（Access token取得時に許可を与えた）アカウントと、上で取得したAccess tokenを入れる。

Google Photoのアルバム名の一覧が表示されれば成功。Access tokenがちゃんと使えることがわかった。

[次回](../google_photo_api_2/)以降で写真の取得、Exif情報の取得あたりのやり方を書いていく。
