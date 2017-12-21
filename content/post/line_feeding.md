---
title: "定期的なリマインドをLINE BOTにやってもらう"
date: 2017-12-21T22:46:24+09:00
categories:
- Tech
tags:
- LINE BOT
- cron
---

自分だけで完結するような定期処理は、適当なアラームアプリあたりに設定すれば良いが、
他人にお願いしていることは、わざわざアラーム設定しておいてと頼むのも角が立つので、こちらからリマインドしたい。

でも面倒なので、LINE BOTに頼むことにした。

<!--more-->

## 構成
[LINE BOTでPUSH通知する](../line_push/)と[Makefileでcronを登録する](../make_cron/)を組み合わせるだけ。

詳細はそれぞれの記事を読んでもらうとして、ソースを記載する。


## スクリプト

```bash
#!/bin/sh
curl -X POST \
-H 'Content-Type:application/json' \
-H 'Authorization: Bearer {CHANNEL_ACCESS_TOKEN}' \
-d '{
    "to": "GROUPID",
    "messages":[
        {
            "type": "text",
            "text": "エサあげた？"
        }
    ]
}' https://api.line.me/v2/bot/message/push
```

ここで、`CHANNEL_ACCESS_TOKEN`はLINE depelopersで取得するトークン。
`GROUPID`は、LINEのグループを識別するためのID。
これの取得方法は前の記事には書いてなかったので説明する。


## GROUP IDの取得
以下のスクリプトをGoogle Apps Scriptでウェブアプリケーションとして導入し、
LINE BOTのWebhook URLに紐付ける。

その状態で、LINEグループにBOT招待すれば、example@gmailにGROUP IDが通知される。

```js
function doPost(e) {
  Logger.log('doPost')
  var events = JSON.parse(e.postData.contents).events;
  events.forEach (function(event) {
    if (event.type == "join") { mailGroupId(event); }
  });
}

function mailGroupId(e) {
  MailApp.sendEmail('example@gmail.com', 'groupId', e.source.groupId);
}
```


## cron登録
以下のような`Makefile`を作って、`make install`すればよい。
ここでは、毎日9時と18時に通知する。

```make
install:
	crontab -l | grep line_feeding.sh || \
		(crontab -l; echo  "0 9,18 * * * /usr/local/bin/line_feeding.sh") | crontab
```


## ユースケース
今回の例は、犬を預かってもらう人にエサをちゃんとあげてくれるようにリマインドするケース。
自分で聞くのは忘れそうだし、BOTに機械的に聞いてもらうことで角が立ちにくい（気がする）。

あとは、今回の例では個人に通知するのではなく、グループに通知する形にしている。
これにより、相手が実行してくれたかどうか聞けるという利点もある（相手がBOTに返信してくれる人なら）。
