---
title: "Yahoo!ジオコーダAPIで住所から経度緯度を取得"
date: 2018-08-16T15:56:34+09:00
categories:
- Tech
tags:
- API
- Ruby
---

Rubyを使う。

<!--more-->

# アプリケーションID登録
まずはAPIを使うための登録。
[アプリケーション登録ページ](https://e.developer.yahoo.co.jp/register)から登録できる。
デフォルトの設定のまま登録でOK。

[アプリケーションIDを登録する](https://www.yahoo-help.jp/app/answers/detail/p/537/a_id/43398)に記入例があるので、
ちゃんとした登録をする場合は参考になる。


# お試しアクセス
登録時に表示されるClient IDを使って、以下のURLにブラウザからアクセスする。
`CLIENT_ID`という部分を自分のClient IDに置き換えること。
東京都の各区の情報が表示されれば成功。

```bash
https://map.yahooapis.jp/geocode/V1/geoCoder?appid=CLIENT_ID&query=東京都
```


# Rubyでアクセス
上と同じく、`CLIENT_ID`という部分を自分のClient IDに置き換えること。

```ruby
require 'json'
require 'open-uri'

CLIENT_ID = 'CLIENT_ID'

class Geocoder
  def exec

    base_url = 'https://map.yahooapis.jp/geocode/V1/geoCoder'
    params = {
      'appid' => CLIENT_ID,
      'query' => '東京都',
      'results' => '1',
      'output' => 'json',
    }
    url = base_url + '?' + URI.encode_www_form(params)

    res = JSON.parse(open(url).read)
    lon, lat = res['Feature'][0]['Geometry']['Coordinates'].split(',')
    puts "経度: #{lon}"
    puts "緯度: #{lat}"
  end
end

geocoder = Geocoder.new
geocoder.exec
```
