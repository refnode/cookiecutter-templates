FROM python:3.10.5-slim-buster@sha256:1310efd0d9dd569e2857448c9803185e41c70ec741b3a24089d36cae8647fa14

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD resources/sources.list /etc/apt/sources.list
ADD resources/pip.conf /etc/pip.conf
ADD requirements.txt /etc/app/requirements.txt
ADD src/{{ cookiecutter.app_name }}/ /usr/local/lib/python3.8/site-packages/{{ cookiecutter.app_name }}
ADD tools/{{ cookiecutter.app_name }} /usr/local/bin/{{ cookiecutter.app_name }}

USER root

RUN \
  useradd -d /app -c "Container User" containeruser \
  && mkdir /app \
  && chmod 0775 /app \
  && chown -R containeruser:containeruser /app \
  && chmod 0755 /usr/local/bin/{{ cookiecutter.app_name }} \
  && apt-get -y update \
  && pip3 install -r /etc/app/requirements.txt \
  && rm -Rf /root/.cache \
  && apt-get -y clean

USER 1000
WORKDIR /app

ENTRYPOINT ["/usr/local/bin/{{ cookiecutter.app_name }}"]
