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

RUN chmod +x /entrypoint.sh

RUN mkdir /geox && \
    curl -o /geox/geoip.dat -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat && \
    curl -o /geox/geosite.dat -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat && \
    curl -o /geox/country.mmdb -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb && \
    curl -o /geox/GeoLite2-ASN.mmdb -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb
RUN apk add python3 py3-yaml
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "-d", "/root/.config/clash", "-ext-ui", "/dashboard" ]