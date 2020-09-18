FROM continuumio/miniconda:latest

# hadolint ignore=SC2102
RUN apt-get update \
 && apt-get install -y \
    gcc \
    fortunes \
    cowsay \
 && pip install apache-airflow[crypto,postgres]

CMD /usr/games/fortune | /usr/games/cowsay
