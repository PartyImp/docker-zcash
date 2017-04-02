#!/usr/bin/env bash

torloglevel="${torloglevel:-warn}"
torpw="${torpw:-w3lc0m31}"
torpwhash=$(tor --hash-password "${torpw}" 2>/dev/null | tail -1)
zcashd_args="${zcashd_args:--onlynet=onion -logtimestamps=0 -blockmaxsize=1000000 -showmetrics=0}"

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
  -listen \
  -daemon \
  ${zcashd_args}
