---
title: "gitのdiffをvimdiffで見る"
date: 2017-10-26T23:34:29+09:00
categories:
- Tech
tags:
- git
- dotfile
---

少し前まで、`git`のdiffに`vimdiff`を使う場合、`git_diff_wrapper`なるファイルを用意して、
`.gitconfig`の`[diff]`セクションに`external = git_diff_wrapper`とするのが主流だった（と思っている）。

今、各種dotfileを見直している中で、このダサいやり方を改善できないか調べたところ、
今の主流は`difftool`を使うやり方のようなので、乗り換えた。

<!--more-->

## .gitconfig
まず早速`.gitconfig`を示す。

```bash
[diff]
    tool = vimdiff
[difftool]
    prompt = false
```

これでOK。ただし、`difftool`を使うのでコマンドが変わる。
`diff`のexternalを変える場合は、あくまで`git diff`が使うツールを変更するという意味になるのだが、
`diff`のtoolオプションを変える場合は、`git difftool`が使うツールを指定するという意味になる。



## alias化
`git_diff_wrapper`手法では`git diff`でよかったのに、今回の方法では`git difftool`と打たないといけないはイマイチなので、
エイリアスを用意する。

```bash
[diff]
    tool = vimdiff
[difftool]
    prompt = false
[alias]
    dt = difftool
```

これでOK。本当は`diff = difftool`としたかったが、もともと用意されているコマンドを上書きするようなエイリアスは作れないらしい。


## リードオンリー解除

さて、これで今までとだいたい同じになったが、カレントのファイルがリードオンリーで開かれるのだけが不満。
diff見ながら手直しするというのはよくあるので、毎回`:set noro`なんて打ってられない。

なぜか以下のようにしたら解決した。これが完成形。

```bash
[diff]
    tool = vimdiff
[difftool]
    prompt = false
[difftool "vimdiff"]
    cmd = vimdiff $LOCAL $REMOTE
[alias]
    dt = difftool
```

`[difftool "vimdiff"]`セクションで`cmd`オプションを指定することで、`difftool`で開くコマンドを指定できる。
ここに編集可能な状態で開くオプションを指定すればいいかなと思っていたが、特になんの指定もなくできた。

`cmd`オプションのデフォルトがどうなってるか知らないけど、リードオンリーな状態で開くようなオプションが指定されているのかな。


## 関連ポスト
- [git showの差分をvimdiffで見る](../git_showtool/)
