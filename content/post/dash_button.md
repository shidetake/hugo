+++
categories = []
date = "2017-05-11T22:31:20+09:00"
draft = false
tags = []
thumbnail = ""
title = "Amazon Dash ButtonからLINE通知"

+++

## dasher導入
他の人が詳しく書いているので割愛。  
個人的には[Amazon Dash Button と slackを連携させる](http://kakts-tec.hatenablog.com/entry/2016/12/10/231205)という記事がとても参考になった。


## LINEへのPUSH通知設定
LINE側の設定は[LINE BOTでPUSH通知する](../line_push/)を参照。

CHANNEL_ACCESS_TOKENとUSERIDは上記事で取得したもの。
MAC_ADDRESSはdasher導入時に取得したものを書くこと。

```json
{"buttons": [
  {
    "name": "joy",
    "address": "MAC_ADDRESS",
    "url": "https://api.line.me/v2/bot/message/push",
    "method": "POST",
    "headers": {
      "Content-Type": "application/json",
      "Authorization": "Bearer {CHANNEL_ACCESS_TOKEN}"},
    "json": true,
    "body": {
      "to": "USERID",
      "messages": [
        {
          "type": "text",
          "text": "JOY!"
        }
      ]
    }
  }
]}
```
