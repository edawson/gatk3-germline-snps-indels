FROM ubuntu:16.04
MAINTAINER Eric T Dawson

RUN apt-get update &&  apt-get install -y \
        autoconf \
        automake \
        bc \
        bsdmainutils \
        build-essential \
        cmake \
        dstat \
        gawk \
        gcc-4.9 \
        git \
        gnupg \
        libcurl4-gnutls-dev \
        libssl-dev \
        libncurses5-dev \
        libbz2-dev \
        liblzma-dev \
        ldc \
        pigz \
        python-dev \
        python-pip \
        python2.7 \
        tar \
        wget \
        zlib1g-dev \
        zlib1g

RUN mkdir /app
WORKDIR /app

ADD GenomeAnalysisTK.jar /app/
ADD picard.jar /app/
ADD gatk /app/
ADD picard /app/

RUN git clone --recursive https://github.com/samtools/htslib.git
RUN cd htslib && autoheader &&  autoconf && ./configure && make -j 4 && make install
ENV PATH="/usr/local/lib:/app:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/lib:/app:$LD_LIBRARY_PATH"

RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
RUN tar xjf samtools-1.3.1.tar.bz2
RUN cd samtools-1.3.1 && make -j 4 && make install

RUN mv GenomeAnalysisTK.jar /usr/bin/
RUN mv picard.jar /usr/bin/picard.jar
COPY jre-8u201-linux-x64.tar.gz /app/
RUN tar xvzf jre-8u201-linux-x64.tar.gz && mkdir -p /opt/jre && mv jre1.8.0_201/ /opt/jre && \
    update-alternatives --install /usr/bin/java java /opt/jre/jre1.8.0_201/bin/java 100
RUN chmod 777 gatk && mv gatk /usr/bin/
RUN chmod 777 gatk-lite && mv gatk-lite /usr/bin/
RUN chmod 777 picard && mv picard /usr/bin/
ENV GATK_JAR=/usr/bin/GenomeAnalysisTK-3.8-1-0.jar
ENV PICARD_JAR=/usr/bin/picard.jar
