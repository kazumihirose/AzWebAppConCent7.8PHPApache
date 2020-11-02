FROM centos:centos7
WORKDIR /tmp

RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum -y install supervisor.noarch git wget curl gnupg2 unzip
RUN yum -y install httpd httpd-devel
# Install PHP 7.3 from remi
RUN yum -y install --enablerepo=epel,remi,remi-php73 libmcrypt libmcrypt-devel
RUN yum -y install --enablerepo=epel,remi,remi-php73 php php-cli php-common php-devel php-fpm php-gd php-mbstring php-mysqlnd php-pdo php-pear php-pecl-apcu php-soap php-xml php-xmlrpc php-bcmath php-mcrypt php-imap php-intl php-pgsql php-pecl-ssh2
# ssh
ENV SSH_PASSWD "root:Docker!"
RUN yum -y install openssh-server \
	&& echo "$SSH_PASSWD" | chpasswd
# supervisord
COPY supervisord.conf /etc/
COPY supervisord-sshd.conf /etc/supervisor/conf.d/
COPY supervisord-phpfpm.conf /etc/supervisor/conf.d/
COPY supervisord-httpd.conf /etc/supervisor/conf.d/

# sshd
COPY sshd_config /etc/ssh/
RUN sshd-keygen

# php-fpm
RUN mkdir /run/php-fpm
COPY php.ini /etc/php.ini
COPY php-fpm.conf /etc/php-fpm.conf

# httpd
COPY httpd/00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf
COPY httpd/15-php.conf /etc/httpd/conf.modules.d/15-php.conf

# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
RUN composer create-project --prefer-dist cakephp/app:3.8 app
WORKDIR /tmp

# other contents
RUN sed -i -e 's#DocumentRoot "/var/www/html"#DocumentRoot "/var/www/html/app/webroot"#' /etc/httpd/conf/httpd.conf
RUN echo $'\n\
<Directory "/var/www/html/app/webroot">\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>\n\
' >> /etc/httpd/conf/httpd.conf


# Port setting
EXPOSE 80 22

# Run
CMD ["/usr/bin/supervisord", "-n"]
