FROM metacubex/mihomo:Alpha
RUN apk add --no-cache curl unzip && \
    # use https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip
    curl -o /gh-pages.zip -L https://github.com/MetaCubeX/metacubexd/archive/gh-pages.zip && unzip /gh-pages.zip -d / && mv /metacubexd-gh-pages /dashboard && \
    # use clash-dashboard but it is deleted
    # curl -o /gh-pages.zip -L https://raw.githubusercontent.com/darknightlab/clash-docker/main/clash-dashboard.zip && unzip /gh-pages.zip -d / && \
    # use yacd
    # curl -o /gh-pages.zip -L https://github.com/haishanh/yacd/archive/gh-pages.zip && unzip /gh-pages.zip -d / && mv /yacd-gh-pages /dashboard && \
    rm -rf /gh-pages.zip && \
    apk del unzip

COPY setenv.py /setenv.py
COPY entrypoint.sh /entrypoint.sh
COPY clash.nft /clash.nft

RUN chmod +x /entrypoint.sh

RUN mkdir /geox && \
    curl -o /geox/geoip.metadb -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb && \
    curl -o /geox/Country.mmdb -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb
RUN apk add python3 py3-yaml nftables
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "-ext-ui", "/dashboard" ]