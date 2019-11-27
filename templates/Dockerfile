FROM python:3.7

EXPOSE 8000

WORKDIR /app

ADD requirements.txt /app

RUN pip install --upgrade pip \
	&& pip install --no-cache-dir -r /app/requirements.txt \
	&& apt-get update \
	&& apt-get install -y nginx \
	&& rm -fr /var/lib/apt/lists

ADD . /app

# TODO: Don't run as root, this will be fixed when sample unit tests are added
# USER www-data

ENTRYPOINT ["/app/scripts/entrypoint.sh"]

# NOTE: You will need to modify the number of workers for your environment
CMD ["scripts/run-copy-assets.sh"]
