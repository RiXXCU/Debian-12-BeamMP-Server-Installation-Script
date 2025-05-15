#!/bin/bash

echo "BeamNG Drive Multiplayer Server installation Script by RiXXCU"
apt update
apt upgrade -y
apt install liblua5.3-0 -y
apt install screen -y
mkdir Beammp
cd Beammp
wget https://github.com/BeamMP/BeamMP-Server/releases/download/v3.4.1/BeamMP-Server.debian.12.x86_64
chmod +x BeamMP-Server.debian.12.x86_64

cat << 'EOF' > /root/Beammp/start-beammp
#!/bin/bash
cd /root/Beammp
screen -dmS beammp ./BeamMP-Server.debian.12.x86_64
screen -ls
ip=$(hostname -I | awk '{print $1}')
echo "Connect to the Server with this IP: $ip"
echo "done"
EOF
chmod +x /root/Beammp/start-beammp

cat << 'EOF'> /etc/rc.local
#!/bin/sh -e
/root/Beammp/start-beammp
echo date -R >> /var/log/sys-start.log
exit 0
EOF
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service
cd /root/Beammp
./start-beammp

configfile="/root/Beammp/ServerConfig.toml"
read -p "Insert your Authkey: " authkey
sed -i "28s|^AuthKey = \".*\"|AuthKey = \"$authkey\"|" "$configfile"


cd /root/Beammp
./start-beammp
