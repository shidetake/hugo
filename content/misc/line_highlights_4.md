+++
categories = []
date = "2017-06-18T14:33:41+09:00"
draft = false
tags = []
thumbnail = ""
title = "KindleのハイライトをLINEに通知する 4"

+++

[前回](../line_highlights_3/)はLINEのBOTにメッセージを送ることで、
ハイライトを取得して返信してくれるようにした。
現状では、設定したページ数だけスクレイピングして、全てのハイライトを返信することになっているので、
何度も同じハイライトが送られてきてしまう。
今回は最新のハイライトだけを返信するようにする。

今回でこのシリーズは最後。


## 方針
今まで取得したハイライトを記録しておいて、
差分だけを返信するという単純な仕様にした。

記録する方法は、これまた単純に外部ファイルに保存するだけ。
容量が増えてきたら、ソートしておく、データベースに記録する、などの工夫が必要になるかもしれないが、
とりあえず問題になるまでは単純な実装にする。


## JSON形式で保存
以下のメソッドで```@highlights```という配列をJSON形式にして保存する。
```'json'```を忘れずに```require```すること。

```ruby
  # ハイライトをJSON形式にして外部ファイルに保存する
  def store_highlights
    File.open(JSON_FILE_NAME, 'w') do |file|
      JSON.dump(@highlights, file)
    end
  end
```

## JSON形式のファイルを読み出し
以下のメソッドでJSON_FILE_NAMEというJSON形式ファイルから```@highlights```配列にデータを読み出す。

```ruby
  # 外部ファイルから既に取得しているハイライトを読み出す
  def restore_highlights
    return unless File.exist?(JSON_FILE_NAME)
    File.open(JSON_FILE_NAME, 'r') do |file|
      @highlights = JSON.load(file)
    end
  end
```

あとは、```@highlights```に存在しないハイライトだけをLINEで送信し、外部ファイルに保存すればよい。
