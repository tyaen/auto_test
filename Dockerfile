# for test
# test test
FROM ubuntu:14.04
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install build-essential
RUN apt-get -y install git
RUN apt-get -y install python
RUN apt-get -y install software-properties-common

#
# https://github.com/dockerfile/java/tree/master/oracle-java8
#
# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-add-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get -y install oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Define $HOME
ENV HOME /root

# Define default command.
CMD ["bash"]

# Install scala
RUN wget http://www.scala-lang.org/files/archive/scala-2.10.4.tgz
RUN mkdir /usr/local/src/scala
RUN tar xvf scala-2.10.4.tgz -C /usr/local/src/scala/
RUN echo 'export SCALA_HOME=/usr/local/src/scala/scala-2.10.4' >> $HOME/.bashrc
RUN echo 'export PATH=$SCALA_HOME/bin:$PATH' >> $HOME/.bashrc
RUN /bin/bash -c ". $HOME/.bashrc"
RUN rm scala-2.10.4.tgz

# Install Apache spark
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-cdh4.tgz
RUN mkdir /usr/local/src/spark
RUN tar xvf spark-1.4.1-bin-cdh4.tgz -C /usr/local/src/spark/
RUN echo 'export SPARK_HOME=/usr/local/src/spark/spark-1.4.1-bin-cdh4' >> $HOME/.bashrc
RUN echo 'export PATH=$SPARK_HOME/bin:$PATH' >> $HOME/.bashrc
RUN /bin/bash -c ". $HOME/.bashrc"
RUN rm spark-1.4.1-bin-cdh4.tgz

# Install Japanese Remix DVD packages
#RUN wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | sudo apt-key add -
#RUN wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | sudo apt-key add -
#RUN wget https://www.ubuntulinux.jp/sources.list.d/utopic.list -O /etc/apt/sources.list.d/ubuntu-ja.list
#RUN apt-get update
#RUN apt-get upgrade
#RUN apt-get install ubuntu-defaults-ja

# Define commonly used env variables
ENV HOME /root
ENV SPARK_HOME /usr/local/src/spark/spark-1.4.1-bin-cdh4

# Install kuromoji.jar for Spark
WORKDIR $HOME 
RUN wget https://github.com/downloads/atilika/kuromoji/kuromoji-0.7.7.tar.gz
RUN tar xzf kuromoji-0.7.7.tar.gz
RUN cp kuromoji-0.7.7/lib/kuromoji-0.7.7.jar $SPARK_HOME/lib/
RUN rm -rf kuromoji-0.7.7
RUN rm kuromoji-0.7.7.tar.gz

# Install Spark Project External Twitter
RUN wget http://central.maven.org/maven2/org/apache/spark/spark-streaming-twitter_2.10/1.4.1/spark-streaming-twitter_2.10-1.4.1.jar
RUN cp spark-streaming-twitter_2.10-1.4.1.jar $SPARK_HOME/lib/
RUN rm spark-streaming-twitter_2.10-1.4.1.jar

# Install twitter4j
RUN apt-get update
RUN apt-get -y install unzip
RUN mkdir twitter4j
RUN wget http://twitter4j.org/archive/twitter4j-3.0.6.zip
RUN unzip twitter4j-3.0.6.zip "lib/*.jar" -d ./twitter4j/
RUN rm twitter4j-3.0.6.zip
RUN mv ./twitter4j/lib/*.jar $SPARK_HOME/lib/
RUN rm -rf ./twitter4j
