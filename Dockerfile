FROM dreamacro/clash-premium:latest
COPY setenv.py /setenv.py
COPY entrypoint.sh /entrypoint.sh
RUN apk add --no-cache wget unzip && \
    wget -O /gh-pages.zip https://github.com/Dreamacro/clash-dashboard/archive/gh-pages.zip && \
    unzip /gh-pages.zip -d / && mv /clash-dashboard-gh-pages /dashboard && \
    chmod +x /entrypoint.sh && \
    rm -rf /gh-pages.zip && \
    apk del wget unzip
RUN apk add python3 py3-yaml
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "-ext-ui", "/dashboard" ]