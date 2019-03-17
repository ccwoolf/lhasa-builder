FROM centos:7 as lhasa-builder
ENV PACKAGE=lhasa VERSION=0.3.1
RUN yum install -y automake gcc gcc-c++ libtool make rpm-build
RUN mkdir -p /root/rpmbuild/SOURCES
RUN curl -Lo /root/rpmbuild/SOURCES/$PACKAGE-$VERSION.tar.gz https://github.com/fragglet/$PACKAGE/releases/download/v$VERSION/$PACKAGE-$VERSION.tar.gz
RUN tar zxvf /root/rpmbuild/SOURCES/$PACKAGE-$VERSION.tar.gz $PACKAGE-$VERSION/rpm.spec && chown root: $PACKAGE-$VERSION/rpm.spec
RUN rpmbuild -ba $PACKAGE-$VERSION/rpm.spec

FROM alpine
VOLUME /out
COPY --from=lhasa-builder /root/rpmbuild/RPMS/x86_64/*.rpm /
COPY --from=lhasa-builder /root/rpmbuild/SRPMS/*.rpm /
CMD cp -v /*.rpm /out
