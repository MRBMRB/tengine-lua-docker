FROM  ubuntu
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update&&apt-get install -y curl build-essential libpcre++-dev libssh-dev 
RUN mkdir /temp||true&&curl http://tengine.taobao.org/download/tengine-2.1.2.tar.gz -o /temp/tengine.tar.gz &&\
       cd /temp/ && tar -xzvf /temp/tengine.tar.gz -C /temp/&&mv /temp/tengine-2.1.2 /temp/tengine && \
      curl https://codeload.github.com/simpl/ngx_devel_kit/tar.gz/v0.3.0 -o /temp/ngx_dev.tar.gz && \
      tar -xzvf /temp/ngx_dev.tar.gz -C /temp/&&mv /temp/ngx_devel_kit-0.3.0 /temp/ngx_dev && \
      curl https://codeload.github.com/openresty/lua-nginx-module/tar.gz/v0.10.5 -o /temp/nginx_lua.tar.gz && \
      tar -xzvf /temp/nginx_lua.tar.gz -C /temp/&&mv /temp/lua-nginx-module-0.10.5 /temp/nginx_lua && \
      curl http://luajit.org/download/LuaJIT-2.0.3.tar.gz -o /temp/lua.tar.gz && \
      tar -xzvf /temp/lua.tar.gz -C /temp/ &&mv /temp/LuaJIT-2.0.3 /temp/lua

ENV LUAJIT_LIB /usr/local/lib/luajit/
ENV LUAJIT_INC /usr/local/include/luajit-2.0/
RUN bash -c "cd /temp/lua&&make&&make install"
WORKDIR /temp/tengine/
RUN ./configure --prefix=/usr/local/tengine --with-ld-opt="-Wl,-rpath,/usr/local/lib" --add-module=/temp/nginx_lua --add-module=/temp/ngx_dev &&make&&make install
WORKDIR /usr/local/tengine/
ENTRYPOINT ["nginx","-g","daemon off"]
