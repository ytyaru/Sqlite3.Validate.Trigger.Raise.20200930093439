#!/usr/bin/env bash
#set -Ceu
#---------------------------------------------------------------------------
# SQLite3のSQL文だけでバリデートする(trriger,raise)。
# CreatedAt: 2020-09-30
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	for path in `ls -1 | grep .sql | sort`; do
		echo "========== $path =========="
		sqlite3 -batch -interactive < "$path"
	done
}
Run "$@"
