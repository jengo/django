FROM python:3.6

WORKDIR /usr/src/app

ADD requirements.txt /usr/src/app

RUN pip install --upgrade pip \
	&& pip install --no-cache-dir -r /usr/src/app/requirements.txt

# Only add what is needed
ADD scripts /usr/src/scripts
ADD templates /usr/src/templates

# Leaving this lower in the layers for CI, don't install the packages again
# CI will build both PostgreSQL and MySQL
ARG PROJECT
ARG DATABASE_TYPE

ENV PROJECT ${PROJECT}
ENV DATABASE_TYPE ${DATABASE_TYPE}

RUN /usr/src/scripts/setup_django.sh

CMD ["bash"]
