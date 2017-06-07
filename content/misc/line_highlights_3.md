+++
categories = []
date = "2017-06-07T22:27:01+09:00"
draft = false
tags = []
thumbnail = ""
title = "KindleのハイライトをLINEに通知する 3"

+++

[前回](../line_highlights_2/)はサーバで起動してLINE通知するところまで。
このままだとサーバ側で手動で起動しないといけない。これを解決する。


## 起動タイミング
### 仕様
cronで周期的に実行する仕様や、手動で合図してから一定時間だけ連続起動する仕様など、いくつか考えたが、
結局は手動で合図したタイミングで1度だけ起動する仕様にした。

LINEでタイミングを通知する方法であれば、手動でも大した手間ではない。

妥協案とも言える仕様だが、この仕様にした一番の理由は、
頻繁にアクセスすると、ロボットと疑われてCAPTCHAでブロックされてしまうため。
これを解除することもできるとは思うが、一気に難易度が上がるので今回は見送ることにした。


### 流れ
以下のような流れで起動要求を伝達する。

LINEで起動要求  
↓   
LINEからGoogle Apps Scriptのスクリプト実行  
↓  
ソケット通信でスクレイピング開始要求

### 実装
まずは前回まで作ったクローラーを、ソケット通信をトリガにして動作するようにする。

```diff
+require 'socket'

+gs = TCPServer.open(12345)
+addr = gs.addr
+addr.shift
+printf("server is on %s\n", addr.join(":"))

 crawler = LineKindleHighlights.new

+loop do
+  s = gs.accept
+  print(s, " is accepted\n")
+
   crawler.scrape
+
+  print(s, " is gone\n")
+  s.close
+end
```

これでポート12345番でアクセスされると1度だけ動作するようになる。

つづいて、LINEをトリガにして動作するスクリプトをGoogle Apps Scriptとして作成する。

```js
function doPost(e) {
  Logger.log('doPost')
  var events = JSON.parse(e.postData.contents).events;
  events.forEach (function(event) {
    if (event.type == "message") { UrlFetchApp.fetch("http://your_server_address.com:12345"); }
  });
}
```

こんな感じでウェブアプリケーションとして導入して、LINE側のWebhookアドレスに紐付けると、
BOTに話しかけたタイミングでソケット通信が飛ぶようになる。

