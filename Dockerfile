# Multi Staged Builds


# Manage lanuage runtime
FROM python:3.11 as pythonBase

RUN RUN groupadd app &&\
    RUN useradd -m -g app appuser
WORKDIR /home/appuser

RUN apt-get update
RUN apt-get install -y curl
RUN python -m pip install --upgrade pip

USER appuser

# Application Libraries
FROM pythonBase as libraries

COPY requirements.txt requirements.txt
RUN python -m pip install --user -r requirements.txt


# service
FROM pythonBase

COPY --from=libraries /home/appuser/.local /home/appuser.local
ENV PATH=/home/appuser/.local:$PATH

COPY . /home/appuser/

ENTRYPOINT [ "flask" ]

