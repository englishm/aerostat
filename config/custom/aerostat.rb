namespace :aero do
  desc "Generate a private key for your aerostat"
  task "genkey" do
    puts "Generating #{ssh_d}/id_rsa..."
    system("mkdir -p #{ssh_d}")
    system("ssh-keygen -C 'aerostat' -P '' -b 2048 -t rsa -f #{ssh_d}/id_rsa")
  end

  desc "Show public key"
  task "pubkey" do
    puts "Public key, #{ssh_d}/id_rsa.pub:"
    system("cat #{ssh_d}/id_rsa.pub")
  end

  desc "Place keys for Chef (copy .gitignored cookbook path)"
  task "placekeys" do
    puts "Copying keys to .gitignored location in Chef cookbook."
    source_dir = "#{ssh_d}"
    dest_dir = File.join(File.dirname(__FILE__),"../../chef/site-cookbooks/aerostat/files/default/secrets")
    ["id_rsa","id_rsa.pub","ssh_known_hosts"].each{|f|
      s = File.join(source_dir,f)
      d = File.join(dest_dir,f)
      puts "`cp #{s} #{d}`"
      system("cp #{s} #{d}")
    }
  end

  desc "Generate known_hosts"
  task "genhosts" do
    puts "Generating #{ssh_d}/ssh_known_hosts..."
    system("mkdir -p #{ssh_d}")
    hosts = []
    host = ''
    puts "Enter hostname(s), one per line (or 'done' when finished):"
    loop do
      host = STDIN.gets.chomp
      break if host == 'done'
      hosts << host
    end
    puts "Fetching host keys..."
    hosts.each{|h|
      system("ssh-keyscan #{h} >> #{ssh_d}/ssh_known_hosts")
    }
  end

  desc "Self-host aerostat development"
  task "selfhost" do
    puts "Preparing aerostat for self-hosted development..."
    # Copy aerostat private key to root authorized_keys
    puts "sudo bash -c 'cat /etc/aerostat/id_rsa.pub >> /root/.ssh/authorized_keys'"
    system("sudo bash -c 'cat /etc/aerostat/id_rsa.pub >> /root/.ssh/authorized_keys'")
    # Create ssh_d + config
    puts 'system("mkdir -p #{ssh_d}")'
    system("mkdir -p #{ssh_d}")
    aerostat_ssh_config=<<EOS
Host aerostat
  Hostname aerostat.mikeenglish.net
  User root
  IdentityFile /etc/aerostat/id_rsa
EOS
    File.open("#{ssh_d}/aerostat_ssh_config","w") do |f|
      f.puts aerostat_ssh_config
    end
    puts 'system("mkdir -p chef/site-cookbooks/aerostat/files/default/secrets")'
    system("mkdir -p chef/site-cookbooks/aerostat/files/default/secrets")
    puts 'system("cp /etc/aerostat/id_rsa chef/site-cookbooks/aerostat/files/default/secrets/")'
    system("cp /etc/aerostat/id_rsa chef/site-cookbooks/aerostat/files/default/secrets/")
    puts 'system("cp /etc/aerostat/id_rsa.pub chef/site-cookbooks/aerostat/files/default/secrets/")'
    system("cp /etc/aerostat/id_rsa.pub chef/site-cookbooks/aerostat/files/default/secrets/")
    puts 'system("cp /etc/ssh/ssh_known_hosts chef/site-cookbooks/aerostat/files/default/secrets/")'
    system("cp /etc/ssh/ssh_known_hosts chef/site-cookbooks/aerostat/files/default/secrets/")
  end
end
