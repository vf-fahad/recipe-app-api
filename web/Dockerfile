FROM python:3.8-slim

ARG APP_NAME=app-name
ARG APP_HOME=/usr/src/app
ARG STATIC_FILE=staticfiles
ARG MEDIA_FILE=mediafiles

WORKDIR ${APP_HOME}/${APP_NAME}

# Create a group and user to run our app
ARG APP_USER=app-name
RUN groupadd -r ${APP_USER} && useradd --no-log-init -r -g ${APP_USER} ${APP_USER}

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential gcc python3-dev libpq-dev postgresql \
  postgresql-contrib python3-venv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY ${APP_NAME}/requirements.txt ${APP_HOME}/requirements.txt

ENV VENV ${APP_HOME}/venv
RUN python3 -m venv $VENV
ENV PATH "$VENV/bin:$PATH"

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r ${APP_HOME}/requirements.txt

EXPOSE 8000

# Copy entrypoint.sh file
COPY entrypoint.sh ${APP_HOME}/

# Copy project
COPY ./${APP_NAME} ${APP_HOME}/${APP_NAME}

# Create static and media file directory
RUN mkdir -p ${APP_HOME}/${APP_NAME}/${STATIC_FILE} ${APP_HOME}/${APP_NAME}/${MEDIA_FILE}

# After evrything get copied and the ownership to APP_USER.
# Even if we change the USER, COPY and ADD with copy the files to docker image as root,
# Docker image should run as non-root user
RUN chown -R ${APP_USER}:${APP_USER} ${APP_HOME}
USER ${APP_USER}

# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]