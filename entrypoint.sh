#!/usr/bin/env bash

torloglevel="${torloglevel:-warn}"
torpw="${torpw:-w3lc0m31}"
torpwhash=$(tor --hash-password "${torpw}" 2>/dev/null | tail -1)
rpcuser=${rpcuser:-zcash}
rpcpw=${rpcpw:-`pwgen 20 1`}
miner=${miner:-1}
minerthreads=${minerthreads:-$(nproc)}
zcashd_args="${zcashd_args:--logtimestamps=0 -blockmaxsize=100000 -showmetrics=0}"

cat << EOT > ~/torrc
Log ${torloglevel} stdout
SocksPort 127.0.0.1:9050 IsolateDestAddr
ControlPort 127.0.0.1:9051
HashedControlPassword ${torpwhash}
EOT

tor -f ~/torrc &

zcashd -proxy=127.0.0.1:9050 \
  -torcontrol=127.0.0.1:9051 \
  -torpassword=${torpw} \
  -rpcuser=${rpcuser} \
  -rpcpassword=${rpcpw} \
  -gen=${miner} \
  -genproclimit=${minerthreads} \
  -onlynet=onion \
  -listen \
  -daemon \
  ${zcashd_args}
