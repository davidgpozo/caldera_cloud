#! /bin/bash
sudo apt update
sudo apt install python3-pip upx golang-go -y
#cd /tmp/
#git clone https://github.com/redcanaryco/atomic-red-team.git
#cd /
git clone https://github.com/mitre/caldera.git --recursive
chmod -R o+w caldera/
cd caldera
pip3 install -r requirements.txt
sed -i 's+api_key_blue: BLUEADMIN123+api_key_blue: blueAPIKeySantander22+g' conf/default.yml
sed -i 's+api_key_red: ADMIN123+api_key_red: redAPIKeySantander22+g' conf/default.yml
sed -i 's+port: 8888+port: 2288+g' conf/default.yml
sed -i 's+    blue: admin+    blue: blueSantander22+g' conf/default.yml
sed -i 's+    red: admin+    red: redSantander22+g' conf/default.yml
sed -i 's+    admin: admin+    admin: redAdminSantander22+g' conf/default.yml
#mv /tmp/atomic-red-team/atomics/* /caldera/plugins/atomic/data/abilities/
#runuser -l ubuntu -c 'cd /caldera && /usr/bin/python3 server.py --insecure &'
#runuser -l ubuntu -c 'cd /caldera && /usr/bin/python3 server.py --insecure &'
/usr/bin/python3 server.py --insecure &
idtask=$!
sleep 30
kill -9 $idtask
/usr/bin/python3 server.py --insecure &
