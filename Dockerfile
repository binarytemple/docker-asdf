# vi: ft=dockerfile

FROM centos:7 as builder

ENV LC_ALL en_US.UTF-8

RUN yum -y update && yum install -y git && yum clean all && rm -rf /var/cache/yum/x86_64/

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf

RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc && echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.profile && echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.profile

ENV PATH="${PATH}:/root/.asdf/shims:/root/.asdf/bin"

RUN . $HOME/.asdf/asdf.sh 

RUN asdf update

RUN asdf plugin-add erlang

RUN asdf plugin-add elixir
 

FROM builder

RUN yum -y update && yum install -y autoconf automake chrpath deltarpm ed flex gcc gcc-c++ git java-1.7.0-openjdk-devel less libxslt libxslt-devel m4 make ncurses-devel openssl-devel perl rpm-build tk-devel which yum-utils zlib-devel && yum clean all && rm -rf /var/cache/yum/x86_64/

ARG erlang_version=21.0-rc2

RUN asdf install erlang ${erlang_version}

RUN asdf global erlang ${erlang_version}

ARG elixir_version=1.6.5

RUN asdf install elixir ${elixir_version}

RUN asdf global elixir ${elixir_version}

RUN asdf global erlang ${erlang_version}

RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8

RUN echo 'export LC_ALL=en_US.UTF-8' >> /etc/profile

CMD /bin/bash
