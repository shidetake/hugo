+++
categories = ["Tech"]
date = "2017-08-01 22:41:29"
tags = ["API","Ruby"]
title = "Picasa APIを使ってGoogle Photoからデジカメ写真だけを取得 2"

+++

[前回](../google_photo_api_1/)の続き。
今回は任意のアルバムから写真の情報を取得する。
<!--more-->

# 写真情報の取得
your_album_nameアルバムから取得する場合は以下のような感じ。

```ruby
require 'picasa'

client = Picasa::Client.new(
  user_id: 'your@email',
  access_token: 'your_access_token'
)

albums = client.album.list.entries
album = albums.find { |a| a.title == 'your_album_name' }

photos = client.album.show(album.id).entries

photos.each do |photo|
  puts "#{photo.id}, #{photo.exif.time}, #{photo.title}, #{photo.exif.model}"
end
```

Exif情報から撮影機器のモデル名を取得することもできた。
これで最初にやりたかったことはほぼできたが、
このスクリプトだと1000枚しか処理できないという欠点があるのでもう少し続ける。


# 大量の写真情報の取得
`start-index`オプションを使って以下のように書くことで、1000枚以上の写真を処理することができる。
ただし、`start-index`の最大値は10001らしいので、この方法でも11000枚までしか処理できない。
11000枚で十分事足りたので、この対処法までは調べていない。

```ruby
PAGE_NUM_MAX = 11

page_num = [album.numphotos / 1000, PAGE_NUM_MAX].min

page_num.times do |page|
  opt = {}
  opt['start-index'] = page * 1000 + 1
  photos = client.album.show(album.id, opt).entries
  photos.each do |photo|
    puts "#{photo.id}, #{photo.exif.time}, #{photo.title}, #{photo.exif.model}"
  end
end
```

albumの指定まではこれまでと変わらないので省略した。
