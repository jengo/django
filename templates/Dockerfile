FROM python:3.6

EXPOSE 8000

WORKDIR /usr/src/app

ADD requirements.txt /usr/src/app

RUN pip install --upgrade pip \
	&& pip install --no-cache-dir -r /usr/src/app/requirements.txt

ADD . /usr/src/app

# USER www-data

# Why use make ?  It's a wrapper to add post container start commands like db migration
CMD ["make","run"]
