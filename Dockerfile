# BATMAN Dockerfile without rstudio, R only.
# use following command to mount docker container on locally controlled Ubuntu server
# docker run -d -ti -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --publish=9000:8787 <container image name>

FROM r-base:latest

MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

## Add /usr/local/bin to PATH
ENV PATH /usr/local/bin/:$PATH

## Download and install RStudio dependencies
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install -t unstable --no-install-recommends \
    libapparmor1 \
    libedit2 \
    libcurl4-openssl-dev \
    libssl1.0.0 \
    libssl-dev \
    psmisc
RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

## install BATMAN dependencies
RUN R -e "install.packages(c('doSNOW','plotrix','devtools'))"
RUN R -e "library(devtools); install_github('jianlianggao/docker-batman/batman')"

## copy runBATMAN.r into /usr/local/bin folder
ADD runBATMAN.R /usr/local/bin
RUN chmod 0755 /usr/local/bin/runBATMAN.R

## Port number
EXPOSE 8787

ENTRYPOINT [ "/bin/sh", "-c", "/usr/local/bin/runBATMAN.R" ]
