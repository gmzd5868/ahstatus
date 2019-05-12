# 服务器端安装记录

## 1. CentOS 7 安装

安装CentOS 7系统

nmtui 设置IP地址等信息

```
yum update -y
yum install -y git docker php telnet


#安装influxdb
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF

yum install influxdb
systemctl start influxdb
systemctl enable influxdb


#不直接对外，因此不需要开放防火墙
influx

> CREATE DATABASE ahstatus


#安装 grafana
cat << EOF > /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

yum install grafana

systemctl start grafana-server 
systemctl enable grafana-server

firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

# http://status.ah.edu.cn:3000 修改密码


systemctl start httpd
systemctl enable httpd

