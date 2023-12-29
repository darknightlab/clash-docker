FROM metacubex/mihomo:Alpha
COPY setenv.py /setenv.py
COPY entrypoint.sh /entrypoint.sh
RUN apk add --no-cache curl unzip && \
    # use clash-dashboard but it is deleted
    curl -o /gh-pages.zip -L https://raw.githubusercontent.com/darknightlab/clash-docker/main/clash-dashboard.zip && unzip /gh-pages.zip -d / && \
    # use yacd
    # curl -o /gh-pages.zip -L https://github.com/haishanh/yacd/archive/gh-pages.zip && unzip /gh-pages.zip -d / && mv /yacd-gh-pages /dashboard && \
    chmod +x /entrypoint.sh && \
    rm -rf /gh-pages.zip && \
    apk del unzip
RUN apk add python3 py3-yaml
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "-ext-ui", "/dashboard" ]