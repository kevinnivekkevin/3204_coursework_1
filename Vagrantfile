Vagrant.configure("2") do |config|

##
##
##  General Wrapper VM config
##
##

  # Wrapper VM specs
  config.vm.box = "hashicorp/bionic64"
  config.vm.provider "vmware_desktop" do |vmware|
    vmware.vmx["memsize"] = "4096"
    vmware.vmx["numvcpus"] = "4"
  end

  #Confluence web interface
  config.vm.network "forwarded_port",
                    guest: 8090,
                    host: 80

  # ELK web interface
  config.vm.network "forwarded_port",
                    guest: 5601,
                    host: 5601

  # Force Docker init using sample
  config.vm.provision "docker" do |init|
    init.run "hello-world",
            name: "init"
  end

  # Docker network creation
  config.vm.provision "shell",
    inline: "docker network create --gateway 10.0.0.1 --subnet 10.0.0.0/24 network_3204"

  # Destroy init container
  config.vm.provision "shell",
    inline: "docker container kill init"



##
##
## Infrastructure - Log source
##
##


  ##
  ## Postgres Docker container
  ##

  # Create container
  config.vm.provision "docker" do |postgres|
    postgres.run "postgres:14",
                  name: "postgres",
                  args: "\
                  -e 'POSTGRES_USER=confluence' \
                  -e 'POSTGRES_PASSWORD=password' \
                  -e 'POSTGRES_DB=confluencedb'"
  end
  # Connect container to network
  config.vm.provision "shell",
    inline: "docker network connect --ip 10.0.0.2 network_3204 postgres"



  ##
  ## Confluence Docker container
  ##

  # Create container
  config.vm.provision "docker" do |confluence|
    confluence.run "atlassian/confluence:7.13.0",
                    name: "confluence",
                    args: "\
                    -p '8090:8090' \
                    -v '/home/vagrant/confluence-home:/var/atlassian/application-data/confluence' \
                    -e 'ATL_LICENSE_KEY=AAABtQ0ODAoPeNp9kV9v0zAUxd/9Ka7EWyWnTmESqxSJNQlbxdJUTbLBgAfXuV0NqR3ZTqHfHjdpYVSCB7/4/jm/e86rR6wh4wdgE2Bsyq6nLITbrIQJC9+SRbdbo8k3lUVjo5CRWCvHhVvwHUZ1y42RdvuOu4ZbK7kKhN4RodUm8D1yj5EzHZJlZ8SWW0y4w+i4lrIrykJyLwUqi+WhxX5fnGdZuornN/fnUvqzlebQzy1f353F04zL5l/qBZo9mnkSzW6vS/qxenhDPzw93dEZCx8HtBeyLyX7mpfiMSqHZkAvurUVRrZOajX8jEajRV7S9/mKLld5UsXlPF/Qqkh9IYoNetYa1gdwW4STEqRK6BoNtEZ/Q+Hg89a59st0PH7WwV/042aYoDhMfA0g0aC0g1paZ+S6c+g3SwtOg+is0zufS0C8IZ5ZcSUuLfNU8Sq9KdOEzj4dEf8XWuG4+X36Cd47WanvSv9QpEgXkX/0ijGSm2eupOW9MQnusdGtv7BE685nk94NX7/M/TKFy/BPJjz4047bJyTBPyH0CqcO2GgDvG2hPgNYku550w1YG954il/X0fxXMC0CFQCRUd9kwqDYeFIFJyQmlQPeMMYDLQIUYpH3kyyXea6e1PzAN2rpSuuUl4M=X02l1' \
                    -e 'ATL_DB_TYPE=postgresql' \
                    -e 'ATL_JDBC_URL=jdbc:postgresql://10.0.0.2:5432/confluencedb' \
                    -e 'ATL_JDBC_USER=confluence' \
                    -e 'ATL_JDBC_PASSWORD=password'"
  end
  # Connect container to network
  config.vm.provision "shell",
    inline: "docker network connect --ip 10.0.0.3 network_3204 confluence"



  ##
  ## Postgres / Confluence config restore
  ##

  # Copy Postgres restore file into Wrapper VM
  config.vm.provision "file",
                      source: "conf/db.sql",
                      destination: "$HOME/db.sql"
  # Run restore script
  config.vm.provision "shell",
                      path: "conf/restorePostgres.sh"

  # Copy Confluence restore file into Wrapper VM
  config.vm.provision "file",
                      source: "conf/confluence.cfg.xml",
                      destination: "$HOME/confluence.cfg.xml"
  # Run restore script
  config.vm.provision "shell",
                      path: "conf/restoreConfluence.sh"

  # Copy PacketBeat config into Wrapper VM
  config.vm.provision "file",
                      source: "conf/packetbeat.yml",
                      destination: "$HOME/packetbeat.yml"
  # Run PacketBeat installer on Confluence container
  config.vm.provision "shell",
                      path: "conf/installPacketbeatConfluence.sh"



##
##
## Infrastructure - Log processor and visualiser
##
##


  ##
  ## Elasticsearch Docker container
  ##

  # Copy Elasticsearch config file into Wrapper VM
  config.vm.provision "file",
                      source: "conf/elasticsearch.yml",
                      destination: "$HOME/elasticsearch.yml"
  # Create container
  config.vm.provision "docker" do |elasticsearch|
    elasticsearch.run "docker.elastic.co/elasticsearch/elasticsearch:8.4.3",
                      name: "elasticsearch",
                      args: "\
                      -v '/home/vagrant/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro' \
                      -e 'ES_JAVA_OPTS=-Xms512m -Xmx512m' \
                      -e 'ELASTIC_PASSWORD=changeme'"
  end
  # Connect container to network
  config.vm.provision "shell",
    inline: "docker network connect --ip 10.0.0.4 network_3204 elasticsearch"



  ##
  ## Logstash Docker container
  ##

  # Copy Logstash config files into Wrapper VM
  config.vm.provision "file",
                      source: "conf/logstash.yml",
                      destination: "$HOME/logstash.yml"
  config.vm.provision "file",
                      source: "conf/logstash.conf",
                      destination: "$HOME/logstash.conf"
  # Create container
  config.vm.provision "docker" do |logstash|
    logstash.run "docker.elastic.co/logstash/logstash:8.4.3",
                      name: "logstash",
                      args: "\
                      -v '/home/vagrant/logstash.yml:/usr/share/logstash/config/logstash.yml:ro' \
                      -v '/home/vagrant/logstash.conf:/usr/share/logstash/pipeline/logstash.conf:ro' \
                      -e 'ES_JAVA_OPTS=-Xmx256m' \
                      -e 'LOGSTASH_INTERNAL_PASSWORD=changeme'"
  end
  # Connect container to network
  config.vm.provision "shell",
    inline: "docker network connect --ip 10.0.0.5 network_3204 logstash"



  ##
  ## Kibana Docker container
  ##

  # Copy Kibana config files into Wrapper VM
  config.vm.provision "file",
                      source: "conf/kibana.yml",
                      destination: "$HOME/kibana.yml"
  # Create container
  config.vm.provision "docker" do |kibana|
    kibana.run "docker.elastic.co/kibana/kibana:8.4.3",
                      name: "kibana",
                      args: "\
                      -v '/home/vagrant/kibana.yml:/usr/share/kibana/config/kibana.yml:ro' \
                      -p '5601:5601' \
                      -e 'ES_JAVA_OPTS=-Xmx256m' \
                      -e 'KIBANA_SYSTEM_PASSWORD=changeme'"
  end
  # Connect container to network
  config.vm.provision "shell",
    inline: "docker network connect --ip 10.0.0.6 network_3204 kibana"

end