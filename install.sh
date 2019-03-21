#Author AdilM
#Devops Eng. At Zigron
#2019Mar20

echo "Installing sensu,rabbitmq and redis along with config"
#sudo yum-config-manager --enable epel; # Didn't pick all epel
sudo amazon-linux-extras install epel
sudo yum install redis -y
#Start redis server
sudo redis-server /etc/redis.conf
#sudo vi /etc/sensu/conf.d/redis.json
BASE_PATH="/etc/sensu/conf.d/"
sudo mkdir -p "$BASE_PATH"
sudo touch /etc/sensu/conf.d/redis.json
sudo chmod 777 /etc/sensu/conf.d/redis.json
sudo touch /etc/sensu/conf.d/api.json
sudo chmod 777 /etc/sensu/conf.d/api.json
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
#sudo mkdir -p "$BASE_PATH"
#sudo chmod 777 /etc/sensu/conf.d/redis.json
sudo truncate -s 0 "$BASE_PATH"redis.json
echo $redis_conf >> "$BASE_PATH"redis.json
sudo truncate -s 0 "$BASE_PATH"api.json
echo $api_conf >> "$BASE_PATH"api.json
sudo systemctl enable redis
sudo systemctl start redis
sudo yum install sensu uchiwa -y
sudo touch /etc/sensu/uchiwa.json
sudo chmod 777 /etc/sensu/uchiwa.json
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
sudo truncate -s 0 /etc/sensu/uchiwa.json
echo $uchiwa_conf >> /etc/sensu/uchiwa.json
sensu_repo="
[sensu]
name=sensu
baseurl=https://sensu.global.ssl.fastly.net/yum/6/$basearch/
gpgcheck=0
enabled=1
"

echo $sensu_repo >> /etc/yum.repos.d/sensu.repo
#sudo yum install rabbitmq-server sensu
#sudo /sbin/service rabbitmq-server start
sudo yum install -y erlang
sudo rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server-3.5.6-1.noarch.rpm
sudo rpm -Uvh rabbitmq-server-3.5.6-1.noarch.rpm
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server
sudo rabbitmqctl add_vhost /sensu
sudo rabbitmqctl add_user sensu pass
sudo rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
sudo rabbitmqctl set_user_tags sensu management
sudo touch /etc/sensu/conf.d/rabbitmq.json
sudo chmod 777 /etc/sensu/conf.d/rabbitmq.json
rabbitmq_conf="{
  \"rabbitmq\": {
    \"host\": \"localhost\",
    \"port\": 5671,
    \"vhost\": \"/sensu\",
    \"user\": \"sensu\",
    \"password\": \"pass\"
  }
}"
sudo truncate -s 0 "$BASE_PATH"rabbitmq.json
echo $rabbitmq_conf >> "$BASE_PATH"rabbitmq.json
sudo systemctl enable sensu-server sensu-api sensu-client
sudo systemctl start sensu-server sensu-api sensu-client
sudo systemctl enable uchiwa
sudo systemctl start uchiwa

sudo /opt/sensu/embedded/bin/gem install sensu-plugins-slack