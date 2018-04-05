#!/bin/sh
CMDNAME=`basename $0`
DATE=`date "+%y%m%d"`
SAVE_DIR="."
FLG_O="FALSE"
USAGE="Usage: $CMDNAME [-o save_dir] filename"


# オプション解析
while getopts o: OPT
do
  case $OPT in
    "o" ) FLG_O="TRUE" ; SAVE_DIR="$OPTARG" ;;
    "*" ) echo "usage";;
  esac
done

# セーブするディレクトリがなかったら終了
if [ ! -d $SAVE_DIR ]; then
    echo $SAVE_DIR "does not exist"
    exit 1
fi

## 練習の名前を受け取る
shift `expr $OPTIND - 1`

if [ $# != 1 ]; then
    echo $USAGE
    exit 1
fi
NAME=$1

## ファイルネームのベースを作る
B_FILENAME=${DATE}_${NAME}

## ファイルネームを作る
function __gen_name () {
    ## 同じ名前が無いか調査
    tmp=`find $SAVE_DIR | grep $B_FILENAME | wc -l`
    NUM=`expr $tmp + 1`

    ## ファイルネーム作る
    FILENAME=${SAVE_DIR}/${B_FILENAME}_${NUM}.mp3
    echo $FILENAME
}

## recをスタート
function __start_rec () {
    REC_FILE=`__gen_name`
    echo "---Now Recording---"
    echo "Save in" $REC_FILE
    echo "Type <C-c> to stop recording"
    rec $REC_FILE
}

function __start_play () {
    echo "Playing" $REC_FILE
    play $REC_FILE
}

function __del () {
    echo "Delete" $REC_FILE
    echo "OK?(y/n)"
    read OK;
    if [ $OK = 'y' ]; then
        rm $REC_FILE
        echo "Deleted" $REC_FILE
    else
        echo "Canceled"
    fi
}

## recを回す
function start () {
    echo "Type <Enter> to start recording"
    while read LINE; do
        if [ $LINE = 'r' ]; then
            __start_play
            echo "Done play" $REC_FILE
        elif [ $LINE = 'd' ]; then
            __del
        else
            __start_rec
            echo "Recording ended"
        fi
        echo "continue recording : <Enter>"
        echo "replay : Type 'r' key"
        echo "delete : Type 'd' key"
        echo "finish : <C-c>"
    done
}

start
