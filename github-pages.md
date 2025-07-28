# 私のGitHubページの作り方
How I Made My GitHub Page

## GitHubページとは？

[GitHub](github.html)はソフトウェアを作る人たちのコミュニティで、[Git](git.html)というツールを使ってプログラムのソースコードを共有できる仕組みになっている。
Gitは、ソースコードだけでなく、**ファイルなら何でも共有できる**。
**ウェブサイトのファイルも共有できる**わけだ。

GitHubでは、Gitを使ってウェブサイトを作る仕組みも提供していて、これが[GitHub Pages](https://pages.github.com/)と呼ばれる。
基本的な使い方は次の通り。

1. GitHubアカウントを作成する。
2. リポジトリを作成する。
3. ウェブページ用のファイルを用意する。
4. リポジトリの設定でPagesを有効にする。

公開URLは `https://ユーザ名.github.io/リポジトリ名/` になる。
ただし、リポジトリ名を `ユーザ名.github.io` にした場合はユーザサイトと呼ばれ、公開URLは特別に `https://ユーザ名.github.io/` になる。

## Markdownを使う方法

ウェブサイトの内容は、好きなツールを使って静的なHTMLファイルを作れば良い。
私は[Markdown](markdown.html)で書いて、コマンドでHTMLに変換することにした。
コマンドは `markdown` で、Debianパッケージにあり、 `apt-get install markdown` でインストールできる。これはPerlで作られている。
[初期のもの](https://daringfireball.net/projects/markdown/)に忠実な実装らしい。

ところが、この `markdown` コマンドは、一度にHTMLに変換できるMarkdownファイルはひとつだけ。
なので、いくつか補助ツールを作る必要があった。

1つめは、ディレクトリの階層をたどって、すべてのMarkdownファイルをHTMLに変換するもの。
対応するHTMLファイルよりMarkdownの方が新しい場合だけ変換する。
また、`markdown` コマンドはHTMLの本体の部分しか作ってくれず、ヘッダやフッタは付けてくれないので、このスクリプトの中で付ける。
その後、コードをきれいに整形する[Tidy](formatters.html)を掛ける。
このスクリプトは `update.sh` と名付けた。

	#!/bin/sh
	find . -name '*.md' | while read -r mdfile; do
		dir=$(dirname "$mdfile")
		base=$(basename "$mdfile" .md)
		htmlfile="$dir/$base.html"

		if [ ! -f "$htmlfile" ] || [ "$mdfile" -nt "$htmlfile" ]; then
			echo "Converting: $mdfile -> $htmlfile"
			cp head._html "$htmlfile"
			markdown "$mdfile" >>"$htmlfile"
			cat tail._html >>"$htmlfile"
			tidy -mq "$htmlfile" 2>/dev/null
		fi
	done

`head._html` は次の通り。

	<!DOCTYPE html>
	<html lang="en">
	<head>
	<meta charset="UTF-8">
	<title>かれは開発室 - Kareha Hub</title>
	<link rel="stylesheet" href="simple.css" />
	<link rel="icon" href="flamingo-favicon.png" type="image/png" />
	</head>
	<body>
	<header>
	<a href="/">かれは開発室 - Kareha Hub</a>
	</header>

`tail._html` は次の通り。

	<footer>
	Contact: <a href="mailto:aki@kareha.org">aki@kareha.org</a><br />
	Styled with <a href="https://simplecss.org/">Simple.css</a>🔗
	</footer>
	</body>
	</html>

2つめは、対応するHTMLファイルよりMarkdownの方が古くても強制的に変換するもの。
ヘッダやフッタを更新した際などに必要になる。
このスクリプトは `force-update.sh` と名付けた。

	#!/bin/sh
	find . -name '*.md' -exec touch '{}' \;
	./update.sh

最後に3つめは、対応するMarkdownがもはや存在しない孤立したHTMLファイルを削除するもの。
このスクリプトは `clean-orphan-html.sh` と名付けた。

	#!/bin/sh
	find . -name '*.html' | while read -r htmlfile; do
		dir=$(dirname "$htmlfile")
		base=$(basename "$htmlfile" .html)
		mdfile="$dir/$base.md"

		if [ ! -f "$mdfile" ]; then
			echo "Removing orphan: $htmlfile"
			rm "$htmlfile"
		fi
	done

テキストエディタの[micro](micro.html)でMarkdownを編集して保存したら、 `Ctrl-b` でシェルコマンド `./update.sh` を実行するという流れだ。
これで私のGitHubページ作りには、ほぼ十分な感じだ。

使っている古風な `markdown` コマンドの整形ルールには注意しないといけない。
コードブロックがタブかスペース4つでインデントしないといけなかったり、表が描けなかったり、箇条書きのインデントもタブかスペース4つ必要だったりする。

## スタイルを整える

最後になったが、スタイルは[Simple.css Framework](https://simplecss.org/)のCSSを使うことにした。
良い感じだ。

(続く。)
