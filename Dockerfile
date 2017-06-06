FROM ubuntu:16.04

MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

LABEL software.version="1.2.12.0"
LABEL version="1.0"
LABEL software="batman"

ENV BATMAN_REVISION "889c91b17ad89092c7f937da8a437a8ab982193e"

# Install R and BATMAN
RUN apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev \
                              libcurl4-openssl-dev libssl-dev git && \
    echo 'options("repos"="http://cran.rstudio.com", download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    R -e "install.packages(c('doSNOW','plotrix','devtools','getopt','optparse'))" && \
    R -e 'library(devtools); install_github("jianlianggao/batman/batman",ref=Sys.getenv("BATMAN_REVISION")[1]);' && \
    R -e 'remove.packages(c("devtools"))' && \
    apt-get purge -y r-base-dev git libcurl4-openssl-dev libssl-dev && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Add runBATMAN.r to /usr/local/bin
ADD runBATMAN.R /usr/local/bin
RUN chmod 0755 /usr/local/bin/runBATMAN.R

# Add tests
ADD runTest1.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/runTest1.sh

# Define entry point, useful for generale use
ENTRYPOINT ["runBATMAN.R"]
