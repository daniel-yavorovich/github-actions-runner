FROM dysnix/github-actions-runner:onbuild

ENV SOLC_VER=0.5.17 \
    SOLC_SUM=c35ce7a4d3ffa5747c178b1e24c8541b2e5d8a82c1db3719eb4433a1f19e16f3 \
    VENVS_ADDITIONAL="build-essential rust google-cloud-sdk"

## required development tools and dependencies
RUN apt-get -y update && apt-get -y install \
      axel postgresql-client libpq-dev libssl-dev && \
    # install solc binary \
    ( cd /usr/local/bin && curl -fsSLo solc https://github.com/ethereum/solidity/releases/download/v${SOLC_VER}/solc-static-linux && \
      printf "${SOLC_SUM}  solc" | sha256sum -c && chmod 755 solc ) && \
    # clean up \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

## rust install is inconsistent (requires `libssl-dev` on Ubuntu or `openssl-devel` on Fedora)
RUN apt-get -y update && \
    for package in ${VENVS_ADDITIONAL}; do \
        install-from-virtual-env $package; \
    done && \
    # clean up \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*
