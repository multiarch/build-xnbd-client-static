FROM multiarch/crossbuild

RUN hg clone https://bitbucket.org/hirofuchi/xnbd

WORKDIR /workdir/xnbd/trunk

RUN mkdir -p /artifacts

ENV CROSS_TRIPLE=armv7l
RUN apt-get install -q -y libglib2.0-dev:armhf
RUN crossbuild cc -c -std=c99 -I/usr/lib/arm-linux-gnueabihf/glib-2.0/include -I/usr/include/glib-2.0 -static xnbd_client.c xnbd_common.c lib/*.c \
 && crossbuild cc -static *.o -pthread /usr/lib/arm-linux-gnueabihf/libglib-2.0.a -o /artifacts/armv7l-xnbd-client-static \
 && cp /artifacts/armv7l-xnbd-client-static /artifacts/armv7l-xnbd-client-static-stripped \
 && crossbuild strip /artifacts/armv7l-xnbd-client-static-stripped

ENV CROSS_TRIPLE=x86_64
RUN apt-get install -q -y libglib2.0-dev
RUN crossbuild cc -c -std=c99 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -I/usr/include/glib-2.0 -static xnbd_client.c xnbd_common.c lib/*.c \
 && crossbuild cc -static *.o -pthread /usr/lib/x86_64-linux-gnu/libglib-2.0.a -o /artifacts/x86_64-xnbd-client-static \
 && cp /artifacts/x86_64-xnbd-client-static /artifacts/x86_64-xnbd-client-static-stripped \
 && crossbuild strip /artifacts/x86_64-xnbd-client-static-stripped

RUN ls -la /artifacts \
 && file /artifacts/*
