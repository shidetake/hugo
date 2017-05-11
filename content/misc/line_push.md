+++
date = "2017-04-17T23:11:57+09:00"
draft = false
title = "LINE BOTでPUSH通知する"

+++

## 登録
- PUSH通知する場合はDeveloper Trialで登録

## Google Apps ScriptでユーザID取得
- 友達に追加したユーザのIDを登録したメールアドレスにメールする
- 以下のコードでウェブアプリケーションとして導入する
  - CHANNEL_ACCESS_TOKENはLINE depelopersで取得できる
  - example@gmail.comは任意のgmailアドレス
  - アプリケーションにアクセスできるユーザーは全員（匿名ユーザーを含む）

```js
var CHANNEL_ACCESS_TOKEN = 'CHANNEL_ACCESS_TOKEN';

function doPost(e) {
  Logger.log('doPost')
  var events = JSON.parse(e.postData.contents).events;
  events.forEach (function(event) {
    if (event.type == "follow") { mailUserId(event); }
  });
}

function mailUserId(e) {
  MailApp.sendEmail('example@gmail.com', 'mailId', e.source.userId);
}
```

## curlでMessaging APIのPUSH通知を使う
- CHANNEL_ACCESS_TOKENは上で使ったものと同じ
- USERIDはプッシュ先
  - 今回は上で取得した自分のユーザIDを使う

```bash
curl -X POST \
-H 'Content-Type:application/json' \
-H 'Authorization: Bearer {CHANNEL_ACCESS_TOKEN}' \
-d '{
    "to": "USERID",
    "messages":[
        {
            "type": "text",
            "text": "Hello, world!"
        }
    ]
}' https://api.line.me/v2/bot/message/push
```

## 関連ポスト
[Amazon Dash ButtonからLINE通知](../dash_button/)
