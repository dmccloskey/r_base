# Dockerfile to build R_base container images
# Based on Ubuntu

FROM r-base:latest
## install R packages
RUN Rscript -e 'install.packages("boot")'
RUN Rscript -e 'install.packages("class")'
RUN Rscript -e 'install.packages("cluster")'
RUN Rscript -e 'install.packages("codetools")'
RUN Rscript -e 'install.packages("foreign")'
RUN Rscript -e 'install.packages("kernsmooth")'
RUN Rscript -e 'install.packages("lattice")'
RUN Rscript -e 'install.packages("mass")'
RUN Rscript -e 'install.packages("matrix")'
RUN Rscript -e 'install.packages("mgcv")'
RUN Rscript -e 'install.packages("nlme")'
RUN Rscript -e 'install.packages("nnet")'
RUN Rscript -e 'install.packages("rpart")'
RUN Rscript -e 'install.packages("spatial")'
RUN Rscript -e 'install.packages("survival")'
RUN Rscript -e 'install.packages("e1071")'
RUN Rscript -e 'install.packages("Amelia")'
RUN Rscript -e 'install.packages("mixOmics")'
## install devtools using R
RUN Rscript -e 'install.packages("devtools")'
## install additional R packages using R
RUN > rscript.R
RUN echo 'source("http://bioconductor.org/biocLite.R")' >> rscript.R
##RUN echo 'biocLite("BiocUpgrade")' >> rscript.R
RUN echo 'biocLite("Biobase")' >> rscript.R
RUN echo 'biocLite("LMGene")' >> rscript.R
RUN echo 'biocLite("pcaMethods")' >> rscript.R
RUN Rscript rscript.R
RUN rm rscript.R
