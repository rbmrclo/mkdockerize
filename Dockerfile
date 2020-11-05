# Use python as base image
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}

# Set up workspace
RUN mkdir -p /src
WORKDIR /src

# Set up pip and install dependencies (i.e mkdocs)
ADD requirements.txt /src/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY docker-entrypoint.sh .
RUN chmod +x ./docker-entrypoint.sh

# port for mkdocs
EXPOSE 8000

ENTRYPOINT ["./docker-entrypoint.sh"]
