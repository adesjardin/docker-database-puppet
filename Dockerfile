# CentOS 6
FROM centos:centos6

# Do this to enable Oracle Linux
# wget http://public-yum.oracle.com/docker-images/OracleLinux/OL6/oraclelinux-6.6.tar.xz
# docker load -i oraclelinux-6.6.tar.xz
# FROM oraclelinux:6.6

RUN yum -y install hostname.x86_64 rubygems ruby-devel gcc git unzip dos2unix
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# configure & install puppet
RUN yum install -y puppet tar
RUN gem install -y highline -v 1.6.21
RUN gem install -y librarian-puppet -v 1.0.3

RUN yum clean all

ADD puppet/Puppetfile /etc/puppet/
ADD puppet/manifests/site.pp /etc/puppet/
ADD puppet/manifests/site2.pp /etc/puppet/

WORKDIR /etc/puppet/
RUN librarian-puppet install

ADD startup.sh /
RUN chmod 0755 /startup.sh

RUN yum -y install wget

RUN mkdir -p /var/tmp/install && chmod 777 /var/tmp/install && mkdir /software &&\
	wget -P /software https://product-installers.s3.amazonaws.com/oracle/db/12.1/linuxamd64_12102_database_1of2.zip &&\
	wget -P /software https://product-installers.s3.amazonaws.com/oracle/db/12.1/linuxamd64_12102_database_2of2.zip  &&\
	puppet apply /etc/puppet/site.pp --verbose
#	rm -rf /software && rm -rf /var/tmp/install && rm -rf /tmp/*

# upload software
#RUN mkdir /var/tmp/install
#RUN chmod 777 /var/tmp/install
#RUN mkdir /software
#COPY linuxamd64_12c_database_1of2.zip /software/
#COPY linuxamd64_12c_database_2of2.zip /software/
#RUN chmod -R 777 /software
#RUN puppet apply /etc/puppet/site.pp --verbose --detailed-exitcodes || [ $? -eq 2 ]
#RUN rm -rf /software/*
#RUN rm -rf /var/tmp/install/*
#RUN rm -rf /var/tmp/*
#RUN rm -rf /tmp/*

EXPOSE 1521
WORKDIR /
CMD /bin/bash
#CMD bash -C '/startup.sh';'bash'
