# global args
ARG __BUILD_DIR__="/build"
ARG OS_VERSION="8.5.2111"



FROM centos:8 as first_stage

ARG __BUILD_DIR__
ARG OS_VERSION
ARG OS_CODENAME="centos"
ARG __USER__="root"
ARG __WORK_DIR__="/root"

ENV \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8"

USER ${__USER__}

COPY "files/" "${__WORK_DIR__}/"

WORKDIR "${__WORK_DIR__}"

RUN \
# import rpm key
    echo '--> import rpm keys' && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial && \
# dependencies
    echo '--> instaling dependencies' && \
    yum --assumeyes --quiet install \
        device-mapper-persistent-data \
        lvm2 \
        yum-utils && \
# build structure
    echo '--> creating build structure' && \
    install --directory --owner="${__USER__}" --group="${__USER__}" --mode=0755 "${__BUILD_DIR__}" && \
# build first stage
    echo '--> building first stage' && \
    yumdownloader --assumeyes --quiet --arch="$(arch),noarch" --destdir="${__WORK_DIR__}" ${OS_CODENAME}-*release-${OS_VERSION%.*}-* && \
    rpm --root "${__BUILD_DIR__}" --initdb && \
    rpm --root "${__BUILD_DIR__}" --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial && \
    rpm --root "${__BUILD_DIR__}" --install --nodeps --noscripts "${__WORK_DIR__}"/${OS_CODENAME}-*release*.rpm && \
    yum --assumeyes --quiet --disablerepo='*' --enablerepo='baseos' --installroot="${__BUILD_DIR__}" --setopt=tsflags='nodocs' --setopt=install_weak_deps='no' install \
        bash \
        centos-*repos \
        coreutils-single \
        glibc-minimal-langpack \
        hostname \
        tar \
        yum && \
# clean up and tweaks...
    echo '--> system settings and tweaks' && \
    sed -i -e '/best=True/a exclude=*.i?86\ntsflags=nodocs' "${__BUILD_DIR__}/etc/yum.conf" && \
    echo 'container' > "${__BUILD_DIR__}/etc/dnf/vars/infra" && \
    echo '%_install_langs C.utf8' > "${__BUILD_DIR__}/etc/rpm/macros.image-language-conf" && \
    :> "${__BUILD_DIR__}/etc/machine-id" && \
    find "${__BUILD_DIR__}/lib/systemd/system" -path '*/sysinit.target.wants/*' \( -type l -o -type f \) -not -name 'systemd-tmpfiles-setup.service' -delete && \
    find "${__BUILD_DIR__}/etc" -path '*/systemd/system/*.wants/*' \( -type l -o -type f \) -delete && \
    rm -f "${__BUILD_DIR__}/lib/systemd/system/anaconda.target.wants"/* && \
    rm -f "${__BUILD_DIR__}/lib/systemd/system/basic.target.wants"/* && \
    rm -f "${__BUILD_DIR__}/lib/systemd/system/local-fs.target.wants"/* && \
    rm -f "${__BUILD_DIR__}/lib/systemd/system/multi-user.target.wants"/* && \
    rm -f "${__BUILD_DIR__}/lib/systemd/system/sockets.target.wants"/*udev* && \
    rm -f "${__BUILD_DIR__}/lib/systemd/system/sockets.target.wants"/*initctl* && \
    if [ -x "${__BUILD_DIR__}/usr/bin/systemctl" ]; then chroot "${__BUILD_DIR__}/" systemctl mask systemd-logind.service getty.target console-getty.service sys-fs-fuse-connections.mount systemd-remount-fs.service dev-hugepages.mount; fi && \
    rm -rf "${__BUILD_DIR__}/usr/share/info"/* && \
    rm -rf "${__BUILD_DIR__}/usr/share/man"/* && \
    rm -rf "${__BUILD_DIR__}/var/cache/yum"/* && \
    rm -rf "${__BUILD_DIR__}/var/lib/dnf"/history.* && \
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
    find "${__BUILD_DIR__}/usr/share/locale" -mindepth 1 -maxdepth 1 -type d -not \( -name 'en' -o -name 'en_US' \) -exec rm -r {} + && \
    find "${__BUILD_DIR__}/usr/share/doc" -mindepth 1 -not -type d -not \( -name 'COPYING*' -o -name 'GPL' -o -name '*LICENSE*' \) -delete && \
    find "${__BUILD_DIR__}/usr/share/doc" -mindepth 1 -type d -empty -delete && \
    find "${__BUILD_DIR__}/var/cache" -type f -delete && \
    find "${__BUILD_DIR__}/etc/yum.repos.d" -not \( -iname '*base*' -o -iname '*appstream*' -o -iname '*extras*' -o -iname '*powertools*' -o -iname '*centosplus*' \) -type f -delete && \
# copy tests
    echo '--> copying test files' && \
    install --owner="${__USER__}" --group="${__USER__}" --mode=0755 --target-directory="${__BUILD_DIR__}/usr/bin" "${__WORK_DIR__}/tests"/* && \
# check version
    echo '--> os version' && \
    cat "${__BUILD_DIR__}/etc/centos-release" && \
# done
    echo '--> all done!'



FROM scratch

ARG __BUILD_DIR__
ARG OS_VERSION

LABEL \
    maintainer="Frederico Martins <https://hub.docker.com/u/fscm/>" \
    vendor="fscm" \
    cmd="docker container run --interactive --rm --tty fscm/centos" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="fscm/centos" \
    org.label-schema.description="A small CentOS Linux image" \
    org.label-schema.url="https://www.centos.org/" \
    org.label-schema.vcs-url="https://github.com/fscm/docker-centos/" \
    org.label-schema.vendor="fscm" \
    org.label-schema.version=${OS_VERSION} \
    org.label-schema.docker.cmd="docker container run --interactive --rm --tty fscm/centos" \
    org.label-schema.docker.cmd.test="docker container run --interactive --rm --tty fscm/centos in_sanity"

COPY --from=first_stage "${__BUILD_DIR__}" "/"

ENV \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8"

CMD ["/bin/bash"]
