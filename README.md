# nginx1.18.0
nginx1.18.0 install

1.配置文件为:nginx.conf

2.通过更改nginx_install_path.txt文件中的路径指定nginx安装的目录路径

3.一键安装脚本chmod +x nginx_install.sh && ./nginx_install.sh

4.若需要更改安装nginx的版本,修改nginx_install.sh脚本中version="1.18.0" 为version="1.需要安装的版本号"

5.nginx管理

nginx启动: /etc/init.d/nginx start

nginx关闭: /etc/init.d/nginx stop

nginx重启: /etc/init.d/nginx restart

nginx重载:/etc/init.d/nginx reload

nginx运行状态: /etc/init.d/nginx status
