server {
    listen 443 http3;
    listen 443 ssl http2;

    proxy_request_buffering off;
    add_header alt-svc 'h3=":443"; ma=86400'; # Absolutely necessary header. This informs the client that HTTP/3 is available.
    add_header Strict-Transport-Security max-age=15768000; # Optional but good, client should always try to use HTTPS, even for initial requests.

    
    server_name ${srv_name};
    
    ssl_certificate /etc/${ssl_certificate};
    ssl_certificate_key /etc/${ssl_key};

    location / {
        proxy_pass ${reverse_proxy_address};
        proxy_hide_header X-Frame-Options;
        include conf.d/includes/reverse_proxy.conf;
        ${additional_configs}
    }
}