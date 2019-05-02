FROM i386/centos:7
RUN set -ex; \
curl http://db.lcs.mit.edu/projects/cstore/cstore0.2.tar.gz | tar xz; \
mv cstore /opt; \
cd /opt/cstore/Build; \
sed -i '/^LZO_LIB/ i LZO_INCLUDE := /usr/include/lzo' makefile.init; \
sed -i 's/\(^SLEEPYCAT_DIRECTORY :=\).*/\1 /opt/bdb' makefile.init; \
sed -i '/^IFLAGS/ s/.*/& -I$(LZO_INCLUDE)/' makefile.init; \
sed -i '/^CFLAGS/ s:.*:& -fpermissive -ansi -include /usr/include/c++/4.8.5/i686-redhat-linux/bits/stdc++.h:' makefile.init; \
sed -i 's/-ldb-4.2 -ldb_cxx-4.2/-Wl,-Bstatic & -Wl,-Bdynamic/' makefile.init; \
sed -i 's/llzo/llzo2/' makefile.init; \
find ../src -type f -print0 | xargs -0 sed -i '\
s/iostream.h/iostream/;\
s/fstream.h/fstream/;\
s/hash_map.h/hash_map/;\
s/list.h/list/;\
s/ValPos\* vp = \(.*\;\)/ValPos\* vp\; vp = \1/g;\
s/\(\s\)\(ofstream\)/\1std::\2/;\
s/\(\s\)\(cerr\)/\1std::\2/;\
s/\(\s\)\(endl\)/\1std::\2/;\
s/\(\s\)\(ios\)/\1std::\2/g;\
s/seekp(ios/seekp(std::ios/;\
'; \
# install additional prerequisites
yum install -y gcc gcc-c++ make lzo-devel bison flex perl emacs-nox gdb valgrind yum-utils; \
# not strictly necessary but in case anything crashes we will want to debug
debuginfo-install -y gcc gcc-c++ lzo-devel;
COPY --from=tenpercent/berkeleydb-4.2.52-busybox-glibc-i386-docker /opt/bdb /opt/bdb
WORKDIR /opt/cstore/Build
RUN set -ex; \
make -k -j$(nproc) 2>error.log || true; \
ln -s /opt/cstore/Build/cstoreqp /usr/local/bin/cstoreqptest
WORKDIR /opt/cstore/src
RUN cat license.txt
