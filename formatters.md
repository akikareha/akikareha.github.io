# お気に入りのフォーマッタたち

My Favorite Formatters

テキストで書くプログラミング言語では、どれもソースコードにはある程度の任意性があって、プログラムとしては同じ意味でも、テキストとしては異なるものを書けてしまう。
そうすると内容自体を比較するのが難しくなってしまう。
そこでこの任意性、つまり形式(フォーマット)を自動で統一するツール、フォーマッタがあると便利なわけ。
それでどのプログラミング言語にもフォーマッタが作られている。

ところが、プログラミング言語によっては、公式のフォーマッタが宣言されてないために、複数の異なるフォーマッタが作られている場合がある。
形式を統一するのが目的のフォーマッタが複数あるのは問題だ。
とはいえ、それぞれ使い勝手が違って、それぞれ良い面があったりするので、悩ましい。
そういう場合は、プロジェクト単位でどのフォーマッタを使うか決めることになる。

そこでまあ、私が個人的に使っている、各プログラミング言語のフォーマッタを載せておこうと思う。

* Lua: [StyLua](https://github.com/JohnnyMorganz/StyLua)🔗
* Python: [Black](https://black.readthedocs.io/)🔗
* HTML: [Tidy](https://www.html-tidy.org/)🔗
* JavaScript: [js-beautify](https://github.com/beautifier/js-beautify)🔗
* CSS: [CSSTidy](https://csstidy.sourceforge.net/)🔗
* sh: [shfmt](https://github.com/mvdan/sh)🔗

優先するのは、Debianパッケージにあること。
また、Node.jsやDenoに依存しないこと。
なるべく好みの言語で作られていること。

以下でそれぞれについてもう少し詳しく述べる。
[micro](micro.html)のプラグイン[fmtonsave](https://github.com/akikareha/micro-fmtonsave-plugin/)🔗での設定方法も載せる。

## Lua

Luaのフォーマッタは[StyLua](https://github.com/JohnnyMorganz/StyLua)🔗がお気に入り。
Rustで作られている。
Debianパッケージには無いが、Rustがあれば `cargo install stylua` でインストールできる。

`fmtonsave` で設定する場合は `setfmtonsave stylua` とする。

## Python

Pythonのフォーマッタは[Black](https://black.readthedocs.io/)🔗がお気に入り。
Pythonで作られている。
Debianパッケージにあり、 `apt-get install black` でインストールできる。

`fmtonsave` で設定する場合は `setfmtonsave black` とする。

## HTML

HTMLのフォーマッタは[Tidy](https://www.html-tidy.org/)🔗がお気に入り。
Cで作られている。
Debianパッケージにあり、 `apt-get install tidy` でインストールできる。

`fmtonsave` で設定する場合は `setfmtonsave tidy -m` とする。
オプションの `-m` は上書き保存。

## JavaScript

JavaScriptのフォーマッタは[js-beautify](https://github.com/beautifier/js-beautify)🔗がお気に入り。
Pythonで作られていると思っているが、JavaScriptも使われているのだろうか。
要調査。
Debianパッケージにあり、 `apt-get install jsbeautifier` でインストールできる。

`fmtonsave` で設定する場合は `setfmtonsave js-beautify-py -r -n -t` とする。
オプションの `-r` は上書き保存、 `-n` はファイルの最後に改行を付ける、 `-t` はインデントをタブにする。

## CSS

CSSのフォーマッタは[CSSTidy](https://csstidy.sourceforge.net/)🔗がお気に入り。
C++で作られている。
Debianパッケージにあり、 `apt-get install csstidy` でインストールできる。

`fmtonsave` で設定する場合は `setfmtonsave csstidy-in-place` とする。
`csstidy-in-place` は自作のシェルスクリプトで、次のようなもの。

	#!/bin/sh
	csstidy $1 /tmp/$1 && echo >> /tmp/$1 && mv /tmp/$1 $1

`csstidy` には上書き保存のオプションが無いので、このようなものを自作する必要があった。
さらに、 `csstidy` はファイルの最後に改行を付けてくれないので、スクリプトの中で付けた。

## sh

shのフォーマッタは[shfmt](https://github.com/mvdan/sh)🔗がお気に入り。
Goで作られている。
Debianパッケージにあり、 `apt-get install shfmt` でインストールできる。

`fmtonsave` で設定する場合は `setfmtonsave shfmt -w` とする。
オプションの `-w` は上書き保存。
