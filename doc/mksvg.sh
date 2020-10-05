#!/usr/bin/env bash
#set -Ceu
#---------------------------------------------------------------------------
# SQLite3のSQL文だけでバリデートする(trriger,raise)。
# CreatedAt: 2020-09-30
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	IsInstallAsciinema() { pip3 list 2>/dev/null | grep -c asciinema; }
	InstallAsciinema() { pip3 install asciinema; }
	IsInstallAsciinema || InstallAsciinema;
	IsInstallNpm() { [ -n "$(which npm)" ] && return 0 || return 1;}
	InstallNpm() {
		sudo apt-get install -y nodejs npm
		node -v; npm -v;
		sudo npm cache clean
		sudo npm install -g n
		sudo n stable
		sudo apt-get purge -y nodejs npm
		node -v; npm -v;
	}
	IsInstallNpm || InstallNpm;
	IsInstallSvgTerm() { [ -n "$(which svg-term)" ] && return 0 || return 1;}
	InstallSvgTerm() { sudo npm install -g svg-term-cli; }
	IsInstallSvgTerm || InstallSvgTerm;
	#sudo npm install -g asciicast2gif

	# asciinema rec 0.json
	# ./run.sh
	# Ctrl + D

	# 不要行の削除
	cat 0.json | \
		sed '/"SQLite version /{n;d;}' | \
		sed '/"SQLite version /d' | \
		sed '/"sqlite> --/{n;d;}' | \
		sed '/"sqlite> --/d' | \
		sed '/"--/{n;d;}' | \
		sed '/"--/d' \
		> 1.json
	# cp 1.json 2.json
	# 手動で不要箇所を削除する

	# 表示行数の取得
	SVG_HEIGHT=$(cat 2.json | grep -oPc '\\r\\n')
	echo $SVG_HEIGHT

	# TSV化
	cat 2.json | tail -n +2 | \
		sed 's/^\[//g' | \
		sed 's/\]$//g' | \
		sed 's/, "/\t"/g' \
		> 3.tsv

	# 時刻の最小化
	paste \
		<(seq 0 $(($(cat 2.json | tail -n +2 | wc -l) - 1)) | xargs -I@ bash -c 'printf "0.%06d\n" @') \
		<(cat 3.tsv | cut -f2) \
		<(cat 3.tsv | cut -f3) \
		> 4.tsv
	cat 2.json | head -n 1 | \
		sed -r 's/("height": )([0-9]+),/\1'"$SVG_HEIGHT"',/g' \
		> 4.json
	cat 4.tsv | \
		sed 's/^/\[/g' | \
		sed 's/$/\]/g' | \
		sed 's/\t"/, "/g' \
		>> 4.json

	# heightが不足していたので手動で調整した。

	time cat 5.json | svg-term > demo.svg
	chromium-browser demo.svg
}
Run "$@"
