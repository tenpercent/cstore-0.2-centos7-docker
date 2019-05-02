FROM i386/centos:7
COPY --from=tenpercent/cstore-0.2-centos7-nodata /opt /opt
WORKDIR /opt/cstore/data
RUN set -ex;
curl http://db.csail.mit.edu/data/data4.tar.gz | tar xz ; \
curl http://db.csail.mit.edu/data/D6.data.ros.gz | gunzip -c > D6.data.ros
RUN  set -ex; \
yum install -y lzo yum-utils gdb valgrind; \
debuginfo-install -y gcc gcc-c++ lzo
WORKDIR ../src
RUN set -ex; \
ln -s /opt/cstore/Build/cstoreqp /usr/local/bin/cstoreqptest; \
cstoreqptest 0 createData.cnf global.cnf || true
