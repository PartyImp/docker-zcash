# Instructions for working with the njg/tor branch

## Basic build and usage

    git clone https://github.com/PartyImp/docker-zcash.git
    git checkout njg/tor
    docker build -t zcashd .
    docker run --name zcashd --rm -v /opt/encrypted/zcash-data:/home/zcash/.zcash -ti zcashd

## Advanced startup 

this container accepts environment variables, the defaults can be found in `entrypoint.sh`.

    docker run --name zcashd \
      --rm \
      -e torpw=$(cat ~/.secretfile) \
      -e torloglevel=debug \
      -e zcashd_args="-onlynet=onion -logtimestamps=1 -blockmaxsize=50000 -showmetrics=1 -gen=1 -genproclimit=12" \
      -v /opt/encrypted/zcash-data:/home/zcash/.zcash \
      -ti zcashd

## using your zcash node

    docker exec -ti zcashd zcash-cli getinfo
    

