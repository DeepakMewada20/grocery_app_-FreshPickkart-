# Nginx Configuration

Copy the production nginx config from the remote server:

```bash
# On the remote server, the config is at:
# /etc/nginx/sites-enabled/freshpickkat

# To copy it here:
# scp root@freshpickkart.com:/etc/nginx/sites-enabled/freshpickkat ./freshpickkat_server/nginx/freshpickkat.conf
```

## Current Setup (already done via certbot)
- Domain: freshpickkart.com
- SSL: Let's Encrypt (via certbot)
- Reverse proxy: nginx → Serverpod on 127.0.0.1:8080/8081/8082
