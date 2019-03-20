#Author AdilM
#Devops Eng. At Zigron
#2019Mar20

echo "Installing sensu,rabbitmq and redis along with config"
sudo yum-config-manager --enable epel;
sudo yum install redis 
#Start redis server
sudo redis-server /etc/redis.conf
sudo vi /etc/sensu/conf.d/redis.json
BASE_PATH="/etc/sensu/conf.d/"
set -x 

redis_conf="{
  \"redis\": {
    \"host\": \"localhost\",
    \"port\": 6379
  }
}"
api_conf="{
  \"api\": {
    \"host\": \"localhost\",
    \"port\": 4567
  }
}"

mkdir -p "$BASE_PATH"
truncate -s 0 "$BASE_PATH"redis.json
echo $redis_conf >> "$BASE_PATH"redis.json
truncate -s 0 "$BASE_PATH"api.json
echo $api_conf >> "$BASE_PATH"api.json

uchiwa_conf="{
    \"sensu\": [
        {
            \"name\": \"Sensu\",
            \"host\": \"localhost\",
            \"ssl\": false,
            \"port\": 4567,
            \"path\": \"\",
            \"timeout\": 5000
        }
    ],
    \"uchiwa\": {
        \"port\": 3000,
        \"stats\": 10,
        \"refresh\": 10000
}
}"
echo $uchiwa_conf >> /etc/sensu/uchiwa.json
sensu_repo="
[sensu]
name=sensu
baseurl=https://sensu.global.ssl.fastly.net/yum/6/$basearch/
gpgcheck=0
enabled=1
"

echo $sensu_repo >> /etc/yum.repos.d/sensu.repo
yum install rabbitmq-server sensu

sudo /sbin/service rabbitmq-server start

sudo rabbitmqctl add_vhost /sensu
sudo rabbitmqctl add_user sensu pass
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

rabbitmq_conf="
{
  \"rabbitmq\": {
    \"host\": \"localhost\",
    \"port\": 5671,
    \"vhost\": \"/sensu\",
    \"user\": \"sensu\",
    \"password\": \"pass\"
  }
}
"
echo $rabbitmq_conf "$BASE_PATH"rabbitmq.json

/opt/sensu/embedded/bin/gem install sensu-plugins-slack

