---
title: "git showの差分をvimdiffで見る"
date: 2017-11-25T20:45:30+09:00
categories:
- Tech
tags:
- git
- dotfile
---

以前、[git diffをvimdiffで見る方法](../git_difftool/)を紹介した。
今回は`git show`を`vimdiff`で見る方法を紹介する。

<!--more-->

## git show
あるコミットの詳細を表示するコマンド。`diff`も表示してくれる。
`git diff`程使う機会は少ないかもしれないが、個人的にはかなりよく使うコマンド。

コードレビューや不具合解析なんかで、過去のコミットでの修正内容を確認するのに便利なんだけど、
クラシックな`diff`で表示されるのが気に入らなかったので`vimdiff`で表示する方法を探していた。

## エイリアス
結論から言うと、`git show`で`vimdiff`を使う方法はわからなかった。
環境変数`GIT_EXTERNAL_DIFF`にうまいこと設定できればできそうな気もするが、情報が少ない。

今回はエイリアスを使った方法にした。
`git show`と言いつつ、裏では`git diff`を使っている。実際、`git show`したときの`diff`は`git diff`を使っているのだから問題ない。

```bash
[alias]
    showtool = "!sh -c 'git difftool "${0}"~ "${0}"'"
```

チルダを使って1世代前のコミットからの差分を見るような形にしている。
`sh -c`を使って`git`を呼び出すような冗長な書き方は、ハッシュやブランチ名を引数として渡すため。

このエイリアスだと引数がないと動かない。
オリジナルの`git show`の場合、引数を指定しないときはHEADを指定したときの動作をするので、これと揃えるために以下のように変更した。

```bash
[alias]
    showtool = "!sh -c 'if [ "sh" == "${0}" ]; then REVISION="HEAD"; else REVISION="${0}"; fi; git difftool $REVISION~ $REVISION'"
```

## おまけ
差分ファイルが大量にあると、全ファイルの差分を表示するので非常にめんどくさいことになる。
そこで、`peco`を使って選択的に差分ファイルを見れるようにしている。これが完成形。

```bash
[alias]
    showtool = "!sh -c 'if [ "sh" == "${0}" ]; then REVISION="HEAD"; else REVISION="${0}"; fi;\
        git log -1 --stat-width=800 $REVISION | grep \"|\" | awk \" {print \\$1}\" | peco | xargs -o git difftool $REVISION~ $REVISION'"
```

なかなかトリッキーなコマンドなので、解説はいつか余裕があるときに書くことにする。
