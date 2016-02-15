# Dockerfile to build R_base container images

# Add R-base to the image
FROM r-base:latest

# File Author / Maintainer
MAINTAINER Douglas McCloskey <dmccloskey87@gmail.com>

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
