FROM nginx

# Out of the box, generate a self signed cert
# If you want to use your own, replace the RUN with ADD to your certificate
# You may need to modify default.conf to point to the new certificate location
RUN mkdir /etc/nginx/ssl \
	&& openssl req -subj '/CN=localhost/O=jengo Django/C=US' -x509 -nodes -days 365 -sha256 -newkey rsa:2048 -keyout /etc/nginx/ssl/jengo_django.key -out /etc/nginx/ssl/jengo_django.crt \
	&& chmod 600 /etc/nginx/ssl/* \
	&& chmod 700 /etc/nginx/ssl

ADD default.conf /etc/nginx/conf.d/default.conf
