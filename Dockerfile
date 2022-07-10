FROM openjdk:8u332-jre-slim

LABEL maintainer="brianhsiung@outlook.com"

COPY debpkg /tmp/debpkg
COPY Apache_OpenOffice_4.1.12_Linux_x86-64_install-deb_zh-CN.tar.gz /tmp

ENV OPENOFFICE_VERSION=4.1.12 \
    OPENOFFICE_HOME=/opt/openoffice4 \
    TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata

ENV DEBIAN_FRONTEND noninteractive
RUN set -eux; \
    sed -i -e 's/deb.debian.org/mirrors.163.com/g' \
        -e 's/security.debian.org/mirrors.163.com/g' /etc/apt/sources.list; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        lsb-release \
        curl \
        procps \
        fontconfig \
        locales \
        wget \
        gnupg2 \
        xorg \
    ; \
    # code
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen; \
    dpkg-reconfigure --frontend=noninteractive locales; \
    update-locale LANG=en_US.UTF-8; \
    # timedatectl Asia/Shanghai
    rm -rf /etc/localtime; ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    # openoffice4
    tar Czxf /tmp /tmp/Apache_OpenOffice_4.1.12_Linux_x86-64_install-deb_zh-CN.tar.gz; \
    dpkg -i /tmp/zh-CN/DEBS/*.deb; \
    dpkg -i /tmp/zh-CN/DEBS/desktop-integration/*.deb; \
    rm -rf /var/lib/apt/lists/* 

ENV LANG=en_US.UTF-8
ENV PATH=$PATH:$OPENOFFICE_HOME/program

RUN set -eux; \
    echo "deb https://notesalexp.org/tesseract-ocr5/$(lsb_release -cs)/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/notesalexp.list; \
    # Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead
    wget -O /tmp/keyfile https://notesalexp.org/debian/alexp_key.asc; \
    apt-key add /tmp/keyfile; \ 
    apt-get update; \
    #dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    #wget -P /tmp "https://notesalexp.org/tesseract-ocr5/$(lsb_release -cs)/pool/main/t/tesseract/libtesseract5_5.1.0-1_$dpkgArch.deb"; \
    #wget -P /tmp "https://notesalexp.org/tesseract-ocr5/$(lsb_release -cs)/pool/main/t/tesseract/tesseract-ocr_5.1.0-1_$dpkgArch.deb"; \
    #wget -P /tmp "https://notesalexp.org/tesseract-ocr5/$(lsb_release -cs)/pool/main/t/tesseract-lang/tesseract-ocr-osd_5.0.0~git39-6572757-2_all.deb"; \
    #wget -P /tmp "https://notesalexp.org/tesseract-ocr5/$(lsb_release -cs)/pool/main/t/tesseract-lang/tesseract-ocr-eng_5.0.0~git39-6572757-2_all.deb"; \
    #wget -P /tmp "https://notesalexp.org/tesseract-ocr5/$(lsb_release -cs)/pool/main/t/tesseract-lang/tesseract-ocr-chi-sim_5.0.0~git39-6572757-2_all.deb"; \
    apt-get install -y --no-install-recommends \
        libarchive13 \
        libharfbuzz0b \
        liblept5 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libgomp1 \
    ; \
    #dpkg -i /tmp/*.deb; \
    dpkg -i /tmp/debpkg/*.deb; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    apt-get remove -y wget gnupg2 lsb-release; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /tmp/*; \
    rm -rf /var/cache/*; \
    rm -rf /var/lib/apt/lists/*
