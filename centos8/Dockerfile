FROM centos:8 as first_stage

ARG OS_CODENAME="centos"
ARG OS_VERSION="8.0.1905"

ENV LANG=LANG=C.utf8

COPY files/ /root/

RUN \
# import rpm key
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial && \
# dependencies
  yum --assumeyes --quiet install \
    device-mapper-persistent-data \
    lvm2 \
    yum-utils && \
# build structure
  install --directory --owner=root --group=root --mode=0755 /build && \
# build first stage
  yumdownloader --assumeyes --quiet --arch=x86_64 --destdir=. ${OS_CODENAME}-release-${OS_VERSION%.*}-${OS_VERSION#*.}* && \
  rpm --root /build --initdb && \
  rpm --root /build --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial && \
  rpm --root /build --install --nodeps --noscripts ${OS_CODENAME}-release*.rpm && \
  yum --assumeyes --quiet --disablerepo='*' --enablerepo='BaseOS' --installroot=/build --setopt=tsflags='nodocs' --setopt=install_weak_deps='no' install \
    bash \
    coreutils-single \
    glibc-minimal-langpack \
    hostname \
    tar \
    yum && \
# clean up and tweaks...
  sed -i '/best=True/a exclude=*.i?86\ntsflags=nodocs' /build/etc/yum.conf && \
  echo 'container' > /build/etc/dnf/vars/infra && \
  echo '%_install_langs C.utf8' > /build/etc/rpm/macros.image-language-conf && \
  :> /build/etc/machine-id && \
  find /lib/systemd/system/sysinit.target.wants -mindepth 1 -not -name systemd-tmpfiles-setup.service -delete && \
  rm -f /etc/systemd/system/*.wants/* && \
  rm -f /lib/systemd/system/anaconda.target.wants/* && \
  rm -f /lib/systemd/system/basic.target.wants/* && \
  rm -f /lib/systemd/system/local-fs.target.wants/* && \
  rm -f /lib/systemd/system/multi-user.target.wants/* && \
  rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
  chroot /build/ systemctl mask systemd-logind.service getty.target console-getty.service sys-fs-fuse-connections.mount systemd-remount-fs.service dev-hugepages.mount && \
  rm -rf /build/usr/share/info/* && \
  rm -rf /build/usr/share/man/* && \
  rm -rf /build/var/cache/yum/* && \
  rm -rf /build/var/lib/dnf/history.* && \
  rm -rf /build/var/log/* && \
  rm -rf /build/sbin/sln && \
  rm -rf /build/tmp/.??* && \
  rm -rf /build/boot && \
  find /build/usr/share/i18n/locales -mindepth 1 -maxdepth 1 -not -name en_US -exec rm -r {} + && \
  find /build/usr/share/locale -mindepth 1 -maxdepth 1 -not \( -name en -o -name en_US \) -type d -exec rm -r {} + && \
  find /build/usr/share/doc -mindepth 1 -not -name COPYING* -not -type d -delete && \
  find /build/usr/share/doc -mindepth 1 -type d -empty -delete && \
  find /build/var/cache -type f -delete && \
  find /build/etc/yum.repos.d -not -iname *base* -type f -delete && \
# copy tests
  #install --directory --owner=root --group=root --mode=0755 /build/usr/bin && \
  install --owner=root --group=root --mode=0755 --target-directory=/build/usr/bin /root/tests/* && \
# check version
  cat /build/etc/centos-release



FROM scratch

LABEL \
  maintainer="Frederico Martins <https://hub.docker.com/u/fscm/>"

ENV LANG=C.utf8

COPY --from=first_stage \
  /build .

CMD ["/bin/bash"]
