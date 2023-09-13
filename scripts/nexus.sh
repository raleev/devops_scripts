wget https://download.sonatype.com/nexus/3/nexus-3.60.0-02-unix.tar.gz

tar -xvf nexus-3.60.0-02-unix.tar.gz

mv nexus-3.60.0-02 nexus

sudo mv nexus /opt/

vim .bashrc

export PATH=/opt/nexus/bin:$PATH
