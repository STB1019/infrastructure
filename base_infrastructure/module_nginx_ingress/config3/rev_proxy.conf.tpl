server {
    listen ${port} http3 reuseport;
    listen [::]:${port} http3 reuseport;

    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    proxy_request_buffering off;

    server_name ${srv_name};
    
    ssl_certificate /etc/${ssl_certificate};
    ssl_certificate_key /etc/${ssl_key};

    location / {
        proxy_pass ${reverse_proxy_address};
        proxy_hide_header X-Frame-Options;
        include conf.d/includes/reverse_proxy.conf;
        ${additional_configs}

        add_header alt-svc 'h3=":${port}"; ma=86400' always;
        proxy_hide_header 'strict-transport-security';
    }
}