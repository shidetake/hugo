---
title: "地域ごとのマンション単価をGoogleマップで見る"
date: 2018-08-25T17:40:38+09:00
categories:
- Tech
tags:
- Ruby
thumbnailImage: /img/reins_map.png
---

最近、新築マンションの購入を検討し始めた。
そこで気になるのが、周辺の相場だ。
ということで、Googleマップのマイマップを使って地域ごとの相場を視覚的に確認できるようにした。

<!--more-->

新築マンションは似たような地域で同時に建つことは稀なので、
中古マンション価格から推測する。

中古マンションは売出し価格と成約価格に乖離があることが珍しくないので、
できれば実態に近い成約価格を使いたい。

[REINS Market Information](http://www.contract.reins.or.jp)というサイトでは、
地域ごとのマンション・戸建の成約価格を調べることができる。

これを使って、Googleマップにインポート可能な形式のデータを作成する。

# スクリーンショット
完成系のイメージはこんな感じ（というか、完成したスクリプトで作ったマップ）。
![image](/img/reins_map.png)

東京都心の単価は高すぎてサチってしまっている。
本来買いたいレンジが単価100万以下なのでしょうがない。

# 成果物
GitHubに[reins_map](https://github.com/shidetake/reins_map)というリポジトリを作成して、成果物をおいた。
使い方等はREADMEを読んでほしい。Rubyを使った。
