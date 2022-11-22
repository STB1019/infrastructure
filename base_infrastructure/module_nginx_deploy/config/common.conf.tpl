map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

ssl_protocols TLSv1.3;
gzip on;

server {
    listen 8080 default_server;

    location /stub_status {
        stub_status;
        allow 172.0.0.0/8;
        deny all;
    }
}

server {
    listen 8081 default_server;

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

    ssl_certificate /etc/${default_ssl_certificate};
    ssl_certificate_key /etc/${default_ssl_key};

    location / {
        return 418;
    }
}