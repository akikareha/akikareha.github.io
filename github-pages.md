# 私のGitHubページの作り方
How I Made My GitHub Page

## GitHubページとは？

[GitHub](github.html)はソフトウェアを作る人たちのコミュニティで、[Git](git.html)というツールを使ってプログラムのソースコードを共有できる仕組みになっている。
Gitは、ソースコードだけでなく、**ファイルなら何でも共有できる**。
**ウェブサイトのファイルも共有できる**わけだ。

GitHubでは、Gitを使ってウェブサイトを作る仕組みも提供していて、これが[GitHubページ](https://pages.github.com/)と呼ばれる。
基本的な使い方は次の通り。

1. GitHubアカウントを作成する。
2. リポジトリを作成する。
3. ウェブページ用のファイルを用意する。
4. リポジトリの設定でPagesを有効にする。

公開URLは `https://ユーザ名.github.io/リポジトリ名/` になる。
ただし、リポジトリ名を `ユーザ名.github.io` にした場合はユーザサイトと呼ばれ、公開URLは特別に `https://ユーザ名.github.io/` になる。

GitHub自体が基本的に無料で使えるし、GitHubページも無料で使えるので、貧乏人には優しく、居心地が良い。
オーナーがMicrosoftであることを除けば…いや、もはや言うまい。

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

スタイルは[Simple.css Framework](https://simplecss.org/)のCSSを使うことにした。
良い感じだ。

## さらに改善する

以上で基本的には十分だが、使っているうちにいくつか不満が出てきたので、次の点について修正してある。

* タイトルを自動で付ける。
* 外部サイトへのリンクを区別する。
* hrタグが見えるようにする。
* モバイルに対応する。

以下に改訂版スクリプトなどを載せる。

### custom.css を追加した

`simple.css` を上書き修正するCSSファイル `custom.css` を追加した。
`hr` タグが見えない問題を修正した。

	hr {
		width: 100%;
		height: 1px;
	}

### extract_title.pl を追加した

Markdownファイルからページのタイトルを取り出すスクリプト `extract_title.pl` を追加した。
一番大きい見出しと、その次の行を使って、タイトルを作る。

	#!/usr/bin/perl
	use strict;
	use warnings;

	my $file = shift or die "Usage: $0 <markdown_file>\n";

	open my $fh, '<', $file or die "Cannot open file '$file': $!\n";

	my $line1 = <$fh>;
	my $line2 = <$fh>;
	close $fh;

	unless ( defined $line1 ) {
	    print "(blank)";
	    exit;
	}

	chomp($line1);
	chomp($line2) if defined $line2;

	$line1 =~ s/^#+\s*//;

	my $title;
	if ( $line1 =~ / - / ) {
	    $title = $line1;
	}
	elsif ( defined $line2 && $line2 ne "" ) {
	    $title = "$line1 - $line2";
	}
	else {
	    $title = $line1;
	}

	my $site_title = "かれは開発室 - Kareha Hub";

	if ($title eq $site_title) {
		print $title;
	} else {
		print "$title | $site_title";
	}

### head._html を改訂した

HTMLのヘッダ `head._html` を改訂した。

修正点の1つめは、タイトルを動的に埋め込むために、テンプレート `{{title}}` に置き換えた。

2つめは、 `simple.css` で見えない `hr` タグを見えるようにするため、追加で `custom.css` を読み込むようにした。

3つめは、モバイルでの見栄えを良くするために、 `viewport` の `meta` タグを追加した。

	<!DOCTYPE html>
	<html lang="en">
	<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>{{title}}</title>
	<link rel="stylesheet" href="simple.css" />
	<link rel="stylesheet" href="custom.css" />
	<link rel="icon" href="flamingo-favicon.png" type="image/png" />
	</head>
	<body>
	<header>
	<a href="/">かれは開発室 - Kareha Hub</a>
	</header>

### update.sh を改訂した

変換のメインのスクリプト `update.sh` を改訂した。

修正点の1つめは、HTMLのヘッダ `head._html` のタイトルのテンプレート `{{title}}` を、 `extract_title.pl` で動的に生成したタイトルで置き換えるようにした。

2つめは、Markdownの段階で、外部サイトへのリンクの直後に絵文字のリンク🔗を追加するようにした。

	#!/bin/sh
	find . -name '*.md' | while read -r mdfile; do
		dir=$(dirname "$mdfile")
		base=$(basename "$mdfile" .md)
		htmlfile="$dir/$base.html"

		if [ ! -f "$htmlfile" ] || [ "$mdfile" -nt "$htmlfile" ]; then
			echo "Converting: $mdfile -> $htmlfile"
			title=$(./extract_title.pl "$mdfile")
			escaped_title=$(echo $title | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')
			sed "s/{{title}}/$escaped_title/" head._html >"$htmlfile"
			cat "$mdfile" | sed -E 's/(\[[^][]+\])\((https?:\/\/[^)]+)\)/\1(\2)🔗/g' | markdown >>"$htmlfile"
			cat tail._html >>"$htmlfile"
			tidy -mq "$htmlfile" 2>/dev/null
		fi
	done

(続く。)
