# Main Dockerfile with images for test, dev, and prod environments

# TODO: lock python version to MAJOR.MINOR
FROM python:3-slim-bookworm AS python-base

########## BASE ########################################################################

FROM python-base AS base
WORKDIR /mypackage/
COPY ./ ./
RUN apt-get update && apt-get upgrade -y \
    && ./scripts/install_meta_packages.sh --install-system-common-packages \
    && groupadd -r python \
    && useradd --create-home --system --gid python python \
    && chown -R python /mypackage/
USER python
RUN pip install --upgrade pip

########## BUILD #######################################################################

FROM base AS package-build
RUN ./scripts/install_meta_packages.sh --install-pip-build-packages  \
    && python -m build --wheel

FROM base AS build
COPY --chown=python --from=package-build /mypackage/dist/ dist/
RUN pip install --no-cache-dir --find-links dist/ mypackage

FROM build AS build-slim
RUN rm -r *
COPY --chown=python Makefile ./

########## TEST ########################################################################

FROM build AS test-build
RUN ./scripts/install_meta_packages.sh --install-pip-dev-packages \
    && pipenv install --dev --system --ignore-pipfile --deploy

FROM test-build AS test
LABEL name={NAME}
LABEL version={VERSION}
RUN ["make", "test"]

########## MAIN ########################################################################

FROM build-slim AS dev
LABEL name={NAME}
LABEL version={VERSION}
CMD ["make", "run-dev"]

FROM build-slim AS prod
LABEL name={NAME}
LABEL version={VERSION}
CMD ["make", "run-prod"]
