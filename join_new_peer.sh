
export KEYPATH="$(pwd)/dtic-01.pem"

echo "Choose the organization of the peer"
echo "1. Agency"
echo "2. Transport"
echo "3. Producer"
echo "4. Provider"
echo "5. Farmacy"

read key

case $key in
    1)
    echo "Selected Agency"
    export ORGPEER="Agency"
    ;;
    2)
    echo "Selected Transport"
    export ORGPEER="Transport"
    ;;
    3)
    echo "Selected Producer"
    export ORGPEER="Producer"
    ;;
    4)
    echo "Selected Provider"
    export ORGPEER="Provider"
    ;;
    5)
    echo "Selected Farmacy"
    export ORGPEER="Farmacy"
    ;;
    *)
    export ORGPEER="none"
    ;;
esac
sleep 1
echo $ORGPEER

if [ -f "$KEYPATH" ]; then

if [ $ORGPEER = "none" ]; then

echo "Fatal error: You haven't introduced a correct organization"
exit -1

else

sudo apt install at
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi

sudo zerotier-cli join 35c192ce9bf1b5b8

sudo docker swarm join --token SWMTKN-1-5dtsgphs5wym0od8vbm504ouw3pxyvp5w2gcsjk6vu094p29lu-bv3env0ju55z7qsmymcekhvgq 10.244.0.2:2377

directory="/home/ubuntu"
if [ -d "$directory" ]
then
    echo "Already exists $directory"
    cd $directory/BCFM
    git reset --hard
    git pull
    echo "\n"
else
    echo "Do not exists $directory, creating..."
    mkdir $directory && cd $directory
    git clone https://github.com/doctorcako/BCFM.git
fi


chmod -R 700 /home/ubuntu/BCFM
cd /home/ubuntu/BCFM/test-network/organizations

sftp -i $KEYPATH ubuntu@54.77.129.237 <<EOF
get -r /home/ubuntu/BCFM/test-network/organizations/peerOrganizations
get -r /home/ubuntu/BCFM/test-network/organizations/ordererOrganizations
exit
EOF
# echo "$ORGPEER"
ssh -i $KEYPATH ubuntu@54.77.129.237 'cd /home/ubuntu/BCFM && [ -d /home/ubuntu/BCFM/logs ] && cd logs || mkdir logs  && [ -f /home/ubuntu/BCFM/logs/peer_updates.txt ] && echo 'Logs of $(date +%m-%d-%Y): $ORGPEER peer added. Update needed' >> peer_updates.txt || echo 'Logs of $(date +%m-%d-%Y): $ORGPEER peer added. Update needed' > peer_updates.txt && exit'

fi
else
echo "The credentials don't exist."

fi