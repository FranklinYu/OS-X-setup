alias find=gfind locate=glocate updatedb=gupdatedb xargs=gxargs \
	tar=gtar sed=gsed awk=gawk \
	grep=ggrep egrep=gegrep fgrep=gfgrep

unalias la gcm
alias la='gls --almost-all' gcm='git commit --verbose -m' \
      gcam='git commit --all --verbose -m' gcob='git checkout -b' \
      gap='git add --patch' gds='git diff --staged'
