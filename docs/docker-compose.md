# Docker compose

Run a production Kimai with a persistent database in a separate mysql container.

You can hit kimai at `http://localhost:8001` and log in with `superadmin` / `changemeplease`.

```yaml
version: '3.5'
services:

  sqldb:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimaiuser
      - MYSQL_PASSWORD=kimaipassword
      - MYSQL_ROOT_PASSWORD=changemeplease
    volumes:
      - /var/lib/mysql
    command: --default-storage-engine innodb
    restart: unless-stopped
    healthcheck:
      test: mysqladmin -pchangemeplease ping -h localhost
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  nginx:
    build: compose
    ports:
      - 8001:80
    volumes:
      - ./nginx_site.conf:/etc/nginx/conf.d/default.conf:ro
      - public:/opt/kimai/public:ro
    restart: unless-stopped
    depends_on:
      - kimai
    healthcheck:
      test:  wget --spider http://nginx/health || exit 1
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  kimai:
    image: kimai/kimai2:fpm-alpine-1.8-prod
    environment:
      - APP_ENV=prod
      - TRUSTED_HOSTS=localhost,nginx,${HOSTNAME}
      - ADMINMAIL=admin@kimai.local
      - ADMINPASS=changemeplease
    volumes:
      - public:/opt/kimai/public
      - var:/opt/kimai/var
      # - ./ldap.conf:/etc/openldap/ldap.conf:z
      # - ./ROOT-CA.pem:/etc/ssl/certs/ROOT-CA.pem:z
    restart: unless-stopped

  postfix:
    image: catatnight/postfix:latest
    environment:
      maildomain: kimai.local
      smtp_user: kimai:kimai
    restart: unless-stopped

volumes:
    var:
    public:
```
