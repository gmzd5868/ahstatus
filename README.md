
## 1. 安装操作系统

   以下文档按照CentOS 7，因此建议安装CentOS 7

   安装完毕后，以root用户执行以下命令：

   特别注意：SELinux会带来问题，因此需要禁用，sed那行就是禁用SELinux的，最后重启。

```
yum update -y
yum install docker
systemctl enable docker
sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
reboot
```

## 2. 生成私钥和公钥

重启后，以root用户登陆，稍微修改以下脚本中的Name-Real和 Name-Email，执行，得到文件 my-sec-key.txt 和 my-pub-key.txt。

my-sec-key.txt 是私钥，自己留着，后面用的到。注意私钥不能有密码保护，如果自己手动生成，一定要注意。

my-pub-key.txt 是公钥，发给我  james@ustc.edu.cn 


```
gpg --batch --gen-key <<EOF
%no-protection
Key-Type:1
Key-Length:1024
Subkey-Type:1
Subkey-Length:1024
Name-Real: HTTPtest USTC
Name-Email: httptest@ustc.edu.cn
Expire-Date:0
EOF

gpg --export-secret-key --armor > /root/my-sec-key.txt
gpg --export --armor > /root/my-pub-key.txt
```

## 3. 运行程序

修改下面SITE=test中的test为自己学校的域名(作为测试点缩写)，执行以下命令，如果完全按照上面的步骤，只要虚拟机不重启，就不用管了。

```
docker run -d --name ahstatus -e SITE=test -v /root/my-sec-key.txt:/my-sec-key.txt bg6cq/ahstatus 

docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower ahstatus
```

## 4. 查看结果

http://status.ah.edu.cn:3000/ 可以查看结果 
