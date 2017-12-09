---
title: "Alexa SkillsでHello worldする"
date: 2017-12-04T22:44:29+09:00
categories:
- Tech
tags:
- Alexa Skills
---

Amazon Echoが届いたので、早速スキルを作ってみることにした。
やはり最初はHello world。

<!--more-->

## 構成
![image](http://ift.tt/2B4AsMG)

Amazon Echoにスキルをインストールして、声でスキルを呼び出す。
呼び出されたスキルは、登録されたAWS Lambdaの関数を呼び出して、処理を実行するという流れ。

## 手順
ざっくり以下のような手順が必要

0. AWS LambdaでAlexaに実行させる関数を作成
0. Amazon DevelopperにてAlexaスキルを作成してAWS Lambda関数に紐付ける
0. Amazon echoにインストール

## AWS Lamda
AWS登録して、ログインしたら、AWS Lamdaの設定画面に進む。
右上にオハイオとか地名が書かれているので、東京にしておく。

関数の作成ボタンを押して、設計図からalexa-skill-kit-sdk-factskillを選ぶ。
基本的な情報は以下のように設定した。

| 設定項目             | 設定                                     |
| --------------       | --------------------                     |
| 名前                 | alexaHello                               |
| ロール               | テンプレートから新しいロールを作成       |
| ロール名             | alexaHello                               |

Lambda関数のコードは以下のようにした。
ちなみにこれは、[alexa/skill-sample-nodejs-hello-world](https://github.com/alexa/skill-sample-nodejs-hello-world)に公開されているindex.jsから必要な部分だけを残した。

```js
'use strict';
const Alexa = require("alexa-sdk");

exports.handler = function(event, context, callback) {
    const alexa = Alexa.handler(event, context);
    alexa.registerHandlers(handlers);
    alexa.execute();
};

const handlers = {
    'LaunchRequest': function () {
        this.emit('SayHello');
    },
    'HelloWorldIntent': function () {
        this.emit('SayHello');
    },
    'SayHello': function () {
        this.response.speak('Hello World!');
        this.emit(':responseReady');
    }
};
```

関数の作成ボタンを押して、次の画面に進む。

トリガーの設定画面が出るので、Alexa Skills Kitを選択して、保存すればAWS Lambda側の設定は完了。
右上にARNが表示されている。スキルが関数を呼び出す際に使うので控えておく。

## Amazon Developper
[Amazon Developper Services and Technologies](http://developer.amazon.com/)にアクセスして、右上のサインインからアカウントを作成する。


## スキル作成
アカウントを作ってログインしたら、amazon alexaのページに進み、左上のメニューから、
"Alexa Skills Kit (ASK) > 始めてみよう"を選ぶ。
この辺のドキュメントは後で読むとして、"スキル開発を始める"。

### スキル情報
スキル情報は以下の通り

| 設定項目     | 設定               |
|--------------|--------------------|
| スキルの種類 | カスタム対話モデル |
| 言語         | Japanese           |
| スキル名     | hello world        |
| 呼び出し名   | hello world        |

この設定で保存して次へ。

### 対話モデル
インテントスキーマ
```
{
  "intents": [
    {
      "intent": "HelloWorldIntent"
    }
  ]
}
```

このインテントはAWS Lambdaで作った関数のfunction名と紐付ける。

サンプル発話
```
HelloWorldIntent hello
```

### 設定
サービスエンドポイントのタイプにAWS LamdaのARNを指定して、
デフォルト欄に、AWS Lambdaで作った関数のARNを入力する。
`arn:aws:lambda:ap-northeast-1:xxxxxxxxxxxx:function:alexaHello`みたいな形式。


### テスト
次の画面でテストできる。画面中ほどにあるサービスシミュレーターで、先ほど入力したARNが選択されていることを確認して、
テキスト入力欄にhelloと書いてhello worldを呼び出す。

サービスレスポンス側にある聴くというボタンを押すと、レスポンスが聴ける。ここでエラーが出ていなければ、スキルからAWS Lambdaの呼び出しは成功。

## 公開情報
あとはインストールするための準備。Skills Beta Testingというテスト用のインストール機能があるのでこれを使う。
これを使うためには、画面左上にある各種設定を完成させてオールグリーンにする必要がある。
ここまで正しくできていれば、残りは"公開情報"と"プライバシーとコンプライアンス"だけのはず。

基本的には全て適当に埋めれば良い。
公開情報は以下のように書いた。


| 設定項目           | 設定                                     |
| --------------     | --------------------                     |
| カテゴリー         | Assistants                               |
| テストの手順       | hello                                    |
| 国と地域           | Amazonがスキルを配布するすべての国と地域 |
| スキルの簡単な説明 | hello                                    |
| スキルの詳細な説明 | hello                                    |
| サンプルフレーズ   | hello                                    |

アイコン用の画像登録も必要。サイズ指定があるのでちゃんと正しいサイズの画像を用意すること。
`imagemagick`があれば以下のコマンドで作れる。

```bash
convert -resize 108x108 original_icon.jpg icon_108.jpg
convert -resize 512x512 original_icon.jpg icon_512.jpg
```

## プライバシーとコンプライアンス

| 設定項目                                                                 | 設定                 |
| --------------                                                           | -------------------- |
| このスキルを使って何かを購入したり、実際にお金を支払うことができますか？ | いいえ               |
| このスキルはユーザーの個人情報を収集しますか？                           | いいえ               |
| このスキルは13歳未満の子供を対象にしていますか？                         | いいえ               |
| 輸出コンプライアンス                                                     | チェック             |
| このスキルは広告を含みますか？                                           | いいえ               |

これで保存を押すと、左側のSkills Beta Testingのステータスがアクティブになるので、テストの管理ボタンを押して設定画面に遷移する。

## Skills Beta Testing
テスターを追加ボタンから自分のメールアドレスを入力すると、テスター招待メールが届く。
2つリンクがあるが、2つ目のリンクが日本人向けのもの。

    JP customers: To get started, follow this link:  
    Enable Alexa skill "hello world"

これをクリックして、スキルを有効化すれば使えるようになる。
