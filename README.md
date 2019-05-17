
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

注意：生成密钥可能需要一段时间，等就是了。

注意：生成密钥可能需要一段时间，等就是了。

注意：生成密钥可能需要一段时间，等就是了。

这一步做完后，再进行下一步 docker ... 命令。


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

运行前请确保/root/my-sec-key.txt 文件存在，否则docker会自动建一个目录  /root/my-sec-key.txt 。

测试运行：

```
docker run -it --name ahstatus -e SITE=test -e DEBUG=1\
     -v /root/my-sec-key.txt:/my-sec-key.txt bg6cq/ahstatus 
```

运行时，会打印一些提示信息，如果数据上传正常，可以CTRL-C终止，改用如下命令正式运行。

```
docker container rm -f ahstatus
docker run -d --name ahstatus -e SITE=test \
     -v /root/my-sec-key.txt:/my-sec-key.txt bg6cq/ahstatus 

docker run -d --name watchtower \
     -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup ahstatus
```

如果运行错误，需要删除先运行的 ahstatus，再按照上面的命令重启。(watchtower是负责自动更新ahstatus的，不需要重启)

```
docker container rm -f ahstatus
```

## 4. 查看结果

http://status.ah.edu.cn:3000/ 可以查看结果 

## 5. 当前测试点

| 测试点缩写 | 学校                         |
| :--------- | :----------------------------
| ustc       | 中国科学技术大学 教育网出口  |
| xcvtc      | 宣城职业技术学院             |
| xcvtc-cernet  | 宣城职业技术学院 教育网出口             |
| whit       | 芜湖职业技术学院           |
| ccert      | CCERT                    |
| chu      | 巢湖学院                    |
| ahstu      | 安徽科技学院                  |
| ahdy      | 安徽电子信息职院                  |
| ahau      | 安徽农业大学                  |
| ahcme      | 安徽机电职业技术学院                  |
| chzu      | 滁州学院                 |
