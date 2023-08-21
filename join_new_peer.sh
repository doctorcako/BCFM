curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi

sudo zerotier-cli join 35c192ce9bf1b5b8

sudo docker swarm join --token SWMTKN-1-5dtsgphs5wym0od8vbm504ouw3pxyvp5w2gcsjk6vu094p29lu-bv3env0ju55z7qsmymcekhvgq 10.244.0.2:2377

directory="/home/ubuntu"
if [-d "$directory"]
then
    cd $directory
else
    mkdir $directory && cd $directory
fi

git clone https://github.com/doctorcako/BCFM.git

chmod -R 700 /home/ubuntu/BCFM
cd /home/ubuntu/BCFM/test-network/organizations

sftp -i $1 ubuntu@54.77.129.237 <<EOF
get -r /home/ubuntu/BCFM/test-network/organizations/peerOrganizations
get -r /home/ubuntu/BCFM/test-network/organizations/ordererOrganizations
exit
EOF




