Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 1000

    # ELK stack container
    config.vm.define "elk" do |elk|
      elk.vm.hostname = "elk"
      elk.vm.network :private_network, ip: "10.0.0.2"
      elk.vm.network "forwarded_port", guest: 5044, host: 5044, auto_correct: true
      elk.vm.network "forwarded_port", guest: 5601, host: 5601, auto_correct: true
      elk.vm.network "forwarded_port", guest: 9200, host: 9200, auto_correct: true
      elk.vm.network "forwarded_port", guest: 9600, host: 9600, auto_correct: true
      elk.vm.provider "docker" do |d|
        d.name = "elk"
        d.image = "sebp/elk"
        d.create_args = ["-it",
						"-e", "ES_JAVA_OPTS=-Xms2g -Xmx2g"
						]
        d.ports = ["5601:5601", "9200:9200", "5044:5044", "9600:9600"]
        d.remains_running = true        
      end
    end

    # Kali container
     config.vm.define "kali" do |kali|
       kali.vm.hostname = "kali"
       kali.vm.network :private_network, ip: "10.0.0.5"
       kali.vm.provider "docker" do |d|
         d.name = "kali"
         d.image = "tknerr/baseimage-ubuntu:18.04"
         d.has_ssh = true
         d.remains_running = true
        end
       kali.vm.provision :shell, :path => "config/kali/kali_setup.sh"
     end

    # Postgres container
    config.vm.define "postgres" do |postgres|    
      postgres.vm.hostname = "postgres"
      postgres.vm.network :private_network, ip: "10.0.0.4"
      postgres.vm.network :forwarded_port, guest: 5432, host: 5432  
      postgres.vm.provider "docker" do |d|
        d.name = "postgres"
        d.image = "postgres:14"
        d.has_ssh = false
        d.remains_running = true      
        d.create_args = ["-e", "POSTGRES_USER=confluence",
                        "-e", "POSTGRES_DB=confluencedb",
                        "-e", "POSTGRES_PASSWORD=password"]
        end    
      postgres.vm.synced_folder 'config/postgres/scripts', '/docker-entrypoint-initdb.d'
    end

    # Confluence container
    config.vm.define "confluence" do |confluence|
      confluence.vm.hostname = "confluence"
      confluence.vm.network :private_network, ip: "10.0.0.3"
      confluence.vm.provider "docker" do |d|
      confluence.vm.network "forwarded_port", guest: 8090, host: 80
      confluence.ssh.username = "vagrant"
      confluence.ssh.password = "vagrant"
        d.name = "confluence"
        d.image = "kevinpook/confluence-7.13.0"
        d.has_ssh = true
        d.remains_running = true
      end
      confluence.vm.synced_folder 'attack/exfiltration', '/docker-entrypoint-initdb.d'
      confluence.vm.provision :shell, :path => "config/confluence/confluence_setup.sh"
    end

end
