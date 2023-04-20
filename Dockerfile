# Multi Staged Builds


# Manage lanuage runtime
FROM python:3.11 as pythonBase

WORKDIR /home/AppUser

RUN apt-get update
RUN apt-get install -y curl
RUN python -m pip install --upgrade pip

USER AppUser

# Application Libraries
FROM pythonBase as libraries

COPY requirements.txt requirements.txt
RUN python -m pip install --user -r requirements.txt


# service
FROM pythonBase

COPY --from=libraries /home/AppUser/.local /home/AppUser.local
ENV PATH=/home/AppUser/.local:$PATH

COPY . /home/AppUser/

ENTRYPOINT [ "flask" ]

