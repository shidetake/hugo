---
title: "Gmailに重要なメールが届いたらLINEに通知する"
date: 2017-12-21T23:37:27+09:00
categories:
- Tech
tags:
- LINE BOT
- fintech
- Google Apps Script
thumbnailImage: /img/gmail2line.png
---

最近はめっきりメールを使わなくなった。iOSもメール機能なんかどうでもいいと思っているのか、
いまいち使い勝手が悪い。Gmailのプッシュ通知に非対応ってどうなの。

それでもAmazonの注文メールやら、航空券の予約完了メールやら、色々な場面で送られてくるので、嫌々ながら使っている。
中には緊急性のあるメールもあって、その筆頭が銀行引き落とし失敗メール。残高が足りずに引き落とされなかったときに送られてくる。
早めに気づいて入金できれば、再度引き落としのタイミングがあって、なんとかカードを止められずにすむ。

今回は、引き落としに失敗した時にLINE通知してくれるシステムを構築する。

<!--more-->

## 参考サイト
先に白状しておくと、この記事は
[Google Apps ScriptでGmailの特定のメールを受信したらLINEと連携して通知する](https://asatte.biz/gmail-line/)という記事のほとんどパクリです。


## 構成
Google Apps ScriptとLINE Messaging APIを組み合わせて使う。
IFTTTあたりを使うともっと簡単に作れるが、ポーリング間隔が数時間と長すぎるので今回はNG。
Google Apps Scriptだと1分間隔でポーリング可能。

![image](/img/gmail2line.png)


## 事前準備
- LINE Messaging APIを使えるようにしておく([別記事参照](../line_push/))。
- Gmailにtreatedラベルを作る
    - 1度処理したメールを再度処理しないようにするためのラベル


## Google Apps Script
以下のようなスクリプトを作る。

Gmailから`QUERY`にマッチするメールを取得して、メールの数だけLINEにメッセージを送る。
処理したメールはtreatedラベルを付けて、再度処理しないようにしている。（そのために`QUERY`で`-label:treated`している）

```js
var CHANNEL_ACCESS_TOKEN = 'YOUR_CHANNEL_ACCESS_TOKEN';
var LINE_USER_ID = 'YOUR_LINE_USER_ID';
var QUERY = '-label:treated subject:未済';

function main() {
  var threads = GmailApp.search(QUERY, 0, 10); 
  var messages = GmailApp.getMessagesForThreads(threads);
  
  for (var i in messages) {
    for (var j in messages[i]) {
      line_push('MUFJからの引き落とし失敗してるよ');
    }
  }
  
  // add label:treated
  var label_treated = GmailApp.getUserLabelByName('treated');
  for (var i in threads) {
    threads[i].addLabel(label_treated);    
  }
}

// LINEにプッシュ通知する
function line_push(message) {
  var postData = {
    "to": LINE_USER_ID,
    "messages" : [
      {
        "type" : "text",
        "text" : message
      }
    ]
  };
  
  var options = {
    "method" : "post",
    "headers" : {
      "Content-Type" : "application/json",
      "Authorization" : "Bearer " + CHANNEL_ACCESS_TOKEN
    },
    "payload" : JSON.stringify(postData)
  };
  
  UrlFetchApp.fetch("https://api.line.me/v2/bot/message/push", options);
}
```


## トリガの設定
Google Apps Scriptのスクリプト編集画面で、編集 > 現在のプロジェクトのトリガーを選択する。
ここで、main関数を任意の時間間隔で実行するように設定できる。
最短は1分なのでとりあえず1分にしておいた。


## おまけ
読めばわかると思うが、今回の例は三菱東京UFJ銀行の口座からの引き落としに失敗したときのケース。
このメールが届くようにするには、三菱東京UFJダイレクトで設定する必要がある（設定したのはだいぶ前なので詳細は忘れた）。

で、みずほ銀行も使っているのでこっちも同じようにしようと思ったら、みずほは通知メールサービスが無いらしい。
結構古い情報だけど、[このブログ記事](http://moneylab.ldblog.jp/archives/51639875.html)によると、銀行によって通知サービスが無かったり、有料だったりする模様。

サブバンクをみずほから新生銀行あたりに乗り換えようかなと思った。
