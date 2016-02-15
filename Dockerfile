# Dockerfile to build R_base container images

FROM debian:jessie

# File Author / Maintainer
MAINTAINER Douglas McCloskey <dmccloskey87@gmail.com>

## From the official r-base docker image for R 3.2.3:
##---------------------------------------------------

## Set a default user. Available via runtime flag `--user docker` 
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly). 
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
		ed \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
	&& echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default

ENV R_BASE_VERSION 3.2.3

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
RUN apt-get update \
	&& apt-get install -t unstable -y --no-install-recommends \
		littler/unstable \
                r-cran-littler/unstable \
		r-base=${R_BASE_VERSION}* \
		r-base-dev=${R_BASE_VERSION}* \
		r-recommended=${R_BASE_VERSION}* \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
        && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
	&& ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

##---------------------------------------------------

# install R packages
RUN Rscript -e 'install.packages("boot",dependencies=TRUE)'
RUN Rscript -e 'install.packages("class",dependencies=TRUE)'
RUN Rscript -e 'install.packages("cluster",dependencies=TRUE)'
RUN Rscript -e 'install.packages("codetools",dependencies=TRUE)'
RUN Rscript -e 'install.packages("foreign",dependencies=TRUE)'
RUN Rscript -e 'install.packages("kernsmooth",dependencies=TRUE)'
RUN Rscript -e 'install.packages("lattice",dependencies=TRUE)'
RUN Rscript -e 'install.packages("mass",dependencies=TRUE)'
RUN Rscript -e 'install.packages("matrix",dependencies=TRUE)'
RUN Rscript -e 'install.packages("mgcv",dependencies=TRUE)'
RUN Rscript -e 'install.packages("nlme",dependencies=TRUE)'
RUN Rscript -e 'install.packages("nnet",dependencies=TRUE)'
RUN Rscript -e 'install.packages("rpart",dependencies=TRUE)'
RUN Rscript -e 'install.packages("spatial",dependencies=TRUE)'
RUN Rscript -e 'install.packages("survival",dependencies=TRUE)'
RUN Rscript -e 'install.packages("e1071",dependencies=TRUE)'
RUN Rscript -e 'install.packages("Amelia",dependencies=TRUE)'
RUN Rscript -e 'install.packages("mixOmics",dependencies=TRUE)'
RUN Rscript -e 'install.packages("pls",dependencies=TRUE)'
RUN Rscript -e 'install.packages("spls",dependencies=TRUE)'
RUN Rscript -e 'install.packages("caret",dependencies=TRUE)'
#RUN Rscript -e 'install.packages("RVAideMemoire",dependencies=TRUE)'
RUN Rscript -e 'install.packages("coin",dependencies=TRUE)'

## install devtools using R
RUN Rscript -e 'install.packages("devtools")'

## install additional R packages using R
RUN > rscript.R
RUN echo 'source("http://bioconductor.org/biocLite.R")' >> rscript.R
##RUN echo 'biocLite("BiocUpgrade")' >> rscript.R
RUN echo 'biocLite("Biobase",ask=FALSE)' >> rscript.R
RUN echo 'biocLite("LMGene",ask=FALSE)' >> rscript.R
RUN echo 'biocLite("pcaMethods",ask=FALSE)' >> rscript.R
RUN echo 'biocLite("ropls",ask=FALSE)' >> rscript.R
RUN echo 'biocLite("pcaMethods",ask=FALSE)' >> rscript.R
RUN Rscript rscript.R

# Cleanup
RUN rm rscript.R

# create an R user
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
    && chmod -R u+rwx $HOME \
    && chown -R user:user $HOME

WORKDIR $HOME
USER user

# set the command
CMD ["R"]
