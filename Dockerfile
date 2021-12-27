FROM python:3.10

ADD requirements.txt /tmp

RUN pip install --upgrade pip \
	&& pip install --no-cache-dir -r /tmp/requirements.txt

ARG PROJECT
ARG DATABASE_TYPE

ENV PROJECT=${PROJECT} \
	DATABASE_TYPE=${DATABASE_TYPE}

WORKDIR /jengo_django

CMD ["bash"]
