FROM python:3.7

EXPOSE 8000

WORKDIR /app

ADD requirements.txt /app

RUN pip install --upgrade pip \
	&& pip install --no-cache-dir -r /app/requirements.txt

ADD . /app

# USER www-data

ENTRYPOINT ["/app/scripts/entrypoint.sh"]
CMD ["python", "manage.py"," runserver"]
