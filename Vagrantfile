Vagrant.configure("2") do |config|

  config.vm.box = "hashicorp/bionic64"
  config.vm.provider "vmware_desktop" do |vmware|
    vmware.vmx["memsize"] = "4096"
    vmware.vmx["numvcpus"] = "4"
  end

  config.vm.provision "docker" do |postgres|
    postgres.run "postgres:14",
                  name: "postgres",
                  args: "-p '5432:5432' \
                  -e 'POSTGRES_USER=confluence' \
                  -e 'POSTGRES_PASSWORD=password' \
                  -e 'POSTGRES_DB=confluencedb'"
  end

  config.vm.provision "docker" do |confluence|
    confluence.run "atlassian/confluence:7.12.4",
                    name: "confluence",
                    args: "-p '8090:8090' \
                    -v '/home/vagrant/confluence-home:/var/atlassian/application-data/confluence' \
                    -e 'ATL_LICENSE_KEY=AAABtQ0ODAoPeNp9kV9v0zAUxd/9Ka7EWyWnTmESqxSJNQlbxdJUTbLBgAfXuV0NqR3ZTqHfHjdpYVSCB7/4/jm/e86rR6wh4wdgE2Bsyq6nLITbrIQJC9+SRbdbo8k3lUVjo5CRWCvHhVvwHUZ1y42RdvuOu4ZbK7kKhN4RodUm8D1yj5EzHZJlZ8SWW0y4w+i4lrIrykJyLwUqi+WhxX5fnGdZuornN/fnUvqzlebQzy1f353F04zL5l/qBZo9mnkSzW6vS/qxenhDPzw93dEZCx8HtBeyLyX7mpfiMSqHZkAvurUVRrZOajX8jEajRV7S9/mKLld5UsXlPF/Qqkh9IYoNetYa1gdwW4STEqRK6BoNtEZ/Q+Hg89a59st0PH7WwV/042aYoDhMfA0g0aC0g1paZ+S6c+g3SwtOg+is0zufS0C8IZ5ZcSUuLfNU8Sq9KdOEzj4dEf8XWuG4+X36Cd47WanvSv9QpEgXkX/0ijGSm2eupOW9MQnusdGtv7BE685nk94NX7/M/TKFy/BPJjz4047bJyTBPyH0CqcO2GgDvG2hPgNYku550w1YG954il/X0fxXMC0CFQCRUd9kwqDYeFIFJyQmlQPeMMYDLQIUYpH3kyyXea6e1PzAN2rpSuuUl4M=X02l1' \
                    -e 'ATL_DB_TYPE=postgresql' \
                    -e 'ATL_JDBC_URL=jdbc:postgresql://10.0.0.2:5432/confluencedb' \
                    -e 'ATL_JDBC_USER=confluence' \
                    -e 'ATL_JDBC_PASSWORD=password'"
  end

  config.vm.network "forwarded_port",
                    guest: 8090,
                    host: 80

  ##### Postgres Restore
  config.vm.provision "file",
                      source: "conf/db.sql",
                      destination: "$HOME/db.sql"
  config.vm.provision "shell",
                      path: "conf/restorePostgres.sh"

  ##### Confluence Restore
  config.vm.provision "file",
                      source: "conf/confluence.cfg.xml",
                      destination: "$HOME/confluence.cfg.xml"
  config.vm.provision "shell",
                      path: "conf/restoreConfluence.sh"

  ##### Network Conf
  config.vm.provision "shell",
                      path: "conf/createDockerNetwork.sh"

  config.vm.provision "shell",
                      path: "conf/attachDockerNetwork.sh"
end