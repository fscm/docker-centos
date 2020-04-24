# global args
ARG __BUILD_DIR__="/build"



FROM centos:7 as first_stage

ARG __BUILD_DIR__
ARG OS_CODENAME="centos"
ARG OS_VERSION="7.7.1908"
ARG __USER__="root"
ARG __WORK_DIR__="/root"

ENV LANG="en_US.utf8"

USER ${__USER__}

COPY "files/" "${__WORK_DIR__}/"

WORKDIR "${__WORK_DIR__}"

RUN \
# import rpm key
  echo '=== import rpm keys ===' && \
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${OS_VERSION%%.*} && \
# 'disable' systemctl command
  echo '=== disabling systemctl ===' && \
  mv /usr/bin/systemctl /usr/bin/systemctl.orig && \
  ln -s /bin/true /usr/bin/systemctl && \
# dependencies
  echo '=== instaling dependencies ===' && \
  yum --assumeyes --quiet install \
    device-mapper-persistent-data \
    lvm2 \
    yum-utils && \
# build structure
  echo '=== creating build structure ===' && \
  install --directory --owner=${__USER__} --group=${__USER__} --mode=0755 "${__BUILD_DIR__}" && \
# build first stage
  echo '=== building first stage ===' && \
  yumdownloader --assumeyes --quiet --arch="$(arch)" --destdir="${__WORK_DIR__}" ${OS_CODENAME}-release-${OS_VERSION/./-}* && \
  rpm --root "${__BUILD_DIR__}" --initdb && \
  rpm --root "${__BUILD_DIR__}" --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${OS_VERSION%%.*} && \
  rpm --root "${__BUILD_DIR__}" --install --nodeps --noscripts "${__WORK_DIR__}"/${OS_CODENAME}-release*.rpm && \
  rpm --root "${__BUILD_DIR__}" --query --file --queryformat '%{NAME}\n' /etc/redhat-release | cut -f 1 -d '-' > "${__BUILD_DIR__}/etc/yum/vars/contentdir" && \
  rpm --root "${__BUILD_DIR__}" --query --file --queryformat '%{VERSION}\n' /etc/redhat-release > "${__BUILD_DIR__}/etc/yum/vars/releasever" && \
  yum --assumeyes --quiet --installroot="${__BUILD_DIR__}" --setopt=tsflags='nodocs' --setopt=override_install_langs="en_US.utf8" install \
    bash \
    coreutils \
    yum \
    yum-plugin-ovl && \
# clean up and tweaks...
  echo '=== system settings and tweaks ===' && \
  sed -i -e '/distroverpkg=centos-release/a exclude=*.i?86\noverride_install_langs=en_US.utf8\ntsflags=nodocs' "${__BUILD_DIR__}/etc/yum.conf" && \
  rm -rf "${__BUILD_DIR__}/usr/share/info"/* && \
  rm -rf "${__BUILD_DIR__}/usr/share/man"/* && \
  rm -rf "${__BUILD_DIR__}/var/cache/yum"/* && \
  rm -rf "${__BUILD_DIR__}/var/log"/* && \
  rm -rf "${__BUILD_DIR__}/sbin/sln" && \
  rm -rf "${__BUILD_DIR__}/dev"/.??* && \
  rm -rf "${__BUILD_DIR__}/home"/.??* && \
  rm -rf "${__BUILD_DIR__}/root"/.??* && \
  rm -rf "${__BUILD_DIR__}/tmp"/.??* && \
  rm -rf "${__BUILD_DIR__}/boot" && \
  rm -rf "${__BUILD_DIR__}/proc" && \
  rm -rf "${__BUILD_DIR__}/sys" && \
  find "${__BUILD_DIR__}/usr/share/i18n/locales" -mindepth 1 -maxdepth 1 -not -name 'en_US' -exec rm -r {} + && \
  find "${__BUILD_DIR__}/usr/lib64/gconv" -mindepth 1 -maxdepth 1 -type f -not -name 'UTF*' -delete && \
  find "${__BUILD_DIR__}/usr/share/locale" -mindepth 1 -maxdepth 1 -not \( -name 'en' -o -name 'en_US' \) -type d -exec rm -r {} + && \
  find "${__BUILD_DIR__}/usr/share/doc" -mindepth 1 -not -name COPYING* -not -type d -delete && \
  find "${__BUILD_DIR__}/usr/share/doc" -mindepth 1 -type d -empty -delete && \
  find "${__BUILD_DIR__}/var/cache" -type f -delete && \
  find "${__BUILD_DIR__}/etc/yum.repos.d" -not -iname '*base*' -type f -delete && \
# copy tests
  echo '=== copying test files ===' && \
  install --owner=${__USER__} --group=${__USER__} --mode=0755 --target-directory="${__BUILD_DIR__}/usr/bin" "${__WORK_DIR__}/tests"/* && \
# check version
  echo '=== os version ===' && \
  cat "${__BUILD_DIR__}/etc/centos-release" && \
# done
  echo '=== all done! ==='



FROM scratch

ARG __BUILD_DIR__

LABEL \
  maintainer="Frederico Martins <https://hub.docker.com/u/fscm/>" \
  vendor="fscm" \
  cmd="docker container run --interactive --rm --tty fscm/centos" \
  params=""

COPY --from=first_stage "${__BUILD_DIR__}" "/"

ENV LANG="en_US.utf8"

CMD ["/bin/bash"]
