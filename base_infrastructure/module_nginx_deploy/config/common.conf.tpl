map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

ssl_protocols TLSv1.2 TLSv1.3;
ssl_early_data on;

#ssl_dhparam /etc/nginx/dhparam2048.pem;
ssl_ciphers TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
ssl_ecdh_curve secp521r1:secp384r1:prime256v1;

ssl_session_cache shared:SSL:5m;
ssl_session_timeout 1h;
ssl_session_tickets off;
ssl_buffer_size 4k; # This is for performance rather than security, the optimal value depends on each site.
                                # 16k default, 4k is a good first guess and likely more performant.

ssl_stapling_verify on;
resolver 127.0.0.11;
resolver_timeout 5s;

gzip off; #https://en.wikipedia.org/wiki/BREACH

error_log /dev/stderr warn;
access_log /dev/stderr;

server {
    listen 8080 default_server;
    access_log /dev/null;

    location /stub_status {
        stub_status;
        allow 172.0.0.0/8;
        deny all;
    }
}

server {
    listen 8081 default_server;
    access_log /dev/null;

    location / {
        return 200 'ok';
    }
}

server {
    listen 80 default_server;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2 default_server;
    proxy_request_buffering off;

    server_name *.${domain}

    ssl_certificate /etc/${default_ssl_certificate};
    ssl_certificate_key /etc/${default_ssl_key};

    location / {
        return 418;
    }
}