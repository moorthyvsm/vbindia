# ── Stage 1: serve with nginx (ultra-light, production-ready) ──────────────────
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy the tracker
COPY index.html /usr/share/nginx/html/index.html

# Custom nginx config — serve on port 8080 (non-root friendly)
RUN printf 'server {\n\
    listen 8080;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    gzip on;\n\
    gzip_types text/html text/css application/javascript;\n\
    add_header Cache-Control "no-cache";\n\
    add_header X-Content-Type-Options nosniff;\n\
    add_header X-Frame-Options SAMEORIGIN;\n\
}\n' > /etc/nginx/conf.d/default.conf

# Drop privileges — run nginx as non-root
RUN sed -i 's|^user.*||' /etc/nginx/nginx.conf \
 && chown -R nginx:nginx /var/cache/nginx /var/run \
 && chmod -R 755 /var/cache/nginx

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
