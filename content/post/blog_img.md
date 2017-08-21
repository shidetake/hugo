+++
categories = ["category","subcategory"]
date = "2017-08-21 22:44:54"
keywords = ["tech"]
tags = ["tag1","tag2"]
title = "IFTTTとGoogle Photoを連携するとブログ用の画像準備がはかどる"

+++

ブログに貼る画像置き場として、Google Photoを選んだ。
github-pageでホスティングしているのだが、画像をアップするのはイマイチかなと。
容量制限はないものの、1GBまでを推奨しているらしいし。

というわけで、Google Photoの画像を**簡単に**直接ブログに貼り付ける方法を模索していたが、
IFTTTを使って直リンクアドレスをメールしてもらうのが一番簡単だった。

<!--more-->

## 設定手順
0. IFTTTでNew Appletボタンをクリック
0. サービスはGoogle Photoを選択
0. トリガはNew photo uploaded
  - 現時点ではこれしか選べない
0. アルバムは適当なものを選ぶ
  - 共有アルバムは選べないので注意
      - 恐らくPicasa APIの仕様
0. アクションサービスはメールを選択
  - メールが嫌いならLINEでもよい
0. アクションはSend me an email
0. Subjectは適当に入れる
  - 例: 画像URL {{CreatedAt}}
      - {{CreatedAt}}はトリガがかかった日時
0. Bodyは{{PhotoUrl}}
0. Create actionボタンを押して完了

## 実行手順
0. トリガ用のアルバムに写真を放り込む
0. 1分程するとメールが届く
0. 開いてURLをコピーしてブログに貼り付ける

## 特徴
- 大きい画像をいい具合に縮小してくれる
  - 細かい条件は不明だが、いい具合に縮小してくれる
  - PicasaのAPIで取得できるURLだとこうなってしまう模様
      - Picasa APIの使い方は[こちら](../google_photo_api_1/)
- 短縮URLにして送ってくれる
  - IFTTTの機能（設定が必要かも）
  - オリジナルアドレスだと長過ぎてブログに貼り付けたくないので助かる
