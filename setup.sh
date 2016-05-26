#!/bin/sh

while getopts :b:c:e: opt
do
    case $opt in
        b)
            BINDIR="$OPTARG"
            ;;
        c)
            COMPLETEDIR="$OPTARG"
            ;;
        e)
            ETCDIR="$OPTARG"
            ;;
    esac
done

[ -z "$ETCDIR"      ] && ETCDIR=/etc/cmdproxy
[ ! -d "$ETCDIR"    ] && mkdir "$ETCDIR"
chmod 755 "$ETCDIR"
[ -z "$COMPLETEDIR" ] && COMPLETEDIR=/usr/share/bash-completion/completions
[ -z "$BINDIR"      ] && BINDIR=/usr/bin

shift $((OPTIND - 1))
[ -n "$1" ] && CMDNAME=$1 || exit 1

[ -f "$ETCDIR/$CMDNAME.command"    ] && ln -fs "$BINDIR/cmdproxy" "$BINDIR/$CMDNAME"
chmod 755 "$BINDIR/$CMDNAME"
[ -f "$ETCDIR/$CMDNAME.completion" ] && cp -f "$ETCDIR/$CMDNAME.completion" "$COMPLETEDIR/$CMDNAME"
chmod 755 "$COMPLETEDIR/$CMDNAME"
