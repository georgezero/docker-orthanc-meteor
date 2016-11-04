FROM ubuntu:16.04
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX
RUN apt-get update && \
    apt-get install -y wget curl vim git zsh unzip rsync tmux screen \
    orthanc dcmtk
RUN apt-get clean -y
RUN apt-get autoclean -y
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/share/doc /usr/share/doc-base /usr/share/man /usr/share/locale /usr/share/zoneinfo /var/cache/debconf/*-old
RUN rm -rf /var/lib/cache /var/lib/log
RUN rm -rf /tmp/*
RUN rm -rf /var/tmp/*

MAINTAINER George Zero <georgezero@trove.nyc>

LABEL description="Orthanc 1.0.0 / Meteor 1.4.2 Development Image"

RUN curl https://install.meteor.com/ | sh
RUN wget -O /root/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
ADD orthanc.json /etc/orthanc/
ADD orthanc /etc/init.d/
RUN chown root:root /etc/init.d/orthanc
RUN chmod 755 /etc/init.d/orthanc

RUN useradd -ms /bin/zsh george
ENV HOME /home/george
RUN chown george /home/george /opt
USER george

ENV METEOR_LOG=debug
ENV METEOR_OFFLINE_CATALOG=1

#RUN METEOR_LOG=debug METEOR_OFFLINE_CATALOG=1 meteor create /opt/app --release 1.4.2
#RUN rm -rf /opt/app

RUN wget -O /home/george/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
RUN mkdir -p /home/george/src/meteor
RUN git clone https://github.com/georgezero/Viewers.git /home/george/src/meteor/Viewers

WORKDIR /home/george/src/meteor
EXPOSE 3000
EXPOSE 4242
EXPOSE 8042

#ENTRYPOINT ["meteor"]
#CMD ["run"]

CMD zsh
