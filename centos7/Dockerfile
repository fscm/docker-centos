FROM centos:7 as first_stage

ARG OS_CODENAME="centos"
ARG OS_VERSION="7.7.1908"

ENV LANG=en_US.UTF-8

COPY files/ /root/

RUN \
# import rpm key
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${OS_VERSION%%.*} && \
# 'disable' systemctl command
  mv /usr/bin/systemctl /usr/bin/systemctl.orig && \
  ln -s /bin/true /usr/bin/systemctl && \
# dependencies
  yum --assumeyes --quiet install \
    yum-utils \
    device-mapper-persistent-data \
    lvm2 && \
# restore systemctl command
  #mv /usr/bin/systemctl.orig /usr/bin/systemctl && \
# build structure
  install --directory --owner=root --group=root --mode=0755 /build/usr/local && \
# copy tests
  cp -R /root/tests /build/usr/local/ && \
  chmod +x /build/usr/local/tests/* && \
# build first stage
  yumdownloader --assumeyes --quiet --destdir=. ${OS_CODENAME}-release-${OS_VERSION/./-}* && \
  rpm --root /build --initdb && \
  rpm --root /build --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${OS_VERSION%%.*} && \
  rpm --root /build --install --nodeps --noscripts ${OS_CODENAME}-release*.rpm && \
  #rpm --root /build --import /build/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${OS_VERSION%%.*} && \
  rpm --root /build --query --file --queryformat '%{NAME}\n' /etc/redhat-release | cut -f 1 -d '-' > /build/etc/yum/vars/contentdir && \
  rpm --root /build --query --file --queryformat '%{VERSION}\n' /etc/redhat-release > /build/etc/yum/vars/releasever && \
  yum --assumeyes --quiet --installroot=/build --setopt=tsflags='nodocs' --setopt=override_install_langs=en_US.utf8 install \
    yum \
    yum-plugin-ovl \
    coreutils \
    bash && \
# clean up and tweaks...
  sed -i '/distroverpkg=centos-release/a override_install_langs=en_US.utf8\ntsflags=nodocs' /build/etc/yum.conf && \
  rm -rf /build/usr/share/info/* && \
  rm -rf /build/usr/share/man/* && \
  rm -rf /build/var/cache/yum/* && \
  rm -rf /build/var/log/* && \
  rm -rf /build/sbin/sln && \
  rm -rf /build/dev/null && \
  find /build/usr/share/i18n/locales -mindepth 1 -maxdepth 1 -not -name en_US -exec rm -r {} + && \
  find /build/usr/share/locale -mindepth 1 -maxdepth 1 -not \( -name en -o -name en_US \) -type d -exec rm -r {} + && \
  find /build/usr/share/doc -mindepth 1 -not -name COPYING* -not -type d -delete && \
  find /build/usr/share/doc -mindepth 1 -type d -empty -delete && \
  find /build/var/cache -type f -delete && \
  find /build/etc/yum.repos.d -not -iname *base* -type f -delete && \
# check version
  cat /build/etc/centos-release



FROM scratch

LABEL \
  maintainer="Frederico Martins <https://hub.docker.com/u/fscm/>"

ENV LANG=en_US.UTF-8

COPY --from=first_stage \
  /build .

CMD ["/bin/bash"]
