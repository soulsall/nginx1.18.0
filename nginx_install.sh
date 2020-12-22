#! /bin/bash
installdir=$(cd `dirname $0`; pwd)
cd $installdir

function install_package()
{
     yum -y install pcre pcre-devel zlib zlib-devel gd-devel gcc gcc-c++ openssl-devel
}

function install_nginx()
{
   nginx_install_dir=$(cat nginx_install_path.txt|grep -v '#')
   mkdir -p $nginx_install_dir
   #install openssl
   openssl_url="wget https://www.openssl.org/source/openssl-1.0.2n.tar.gz"
   if [ ! -f "openssl-1.0.2n.tar.gz" ];then
       echo "beginnging download package of openssl-1.0.2n.tar.gz"
       wget $openssl_url
   fi
   if [ ! -d "$nginx_install_dir/openssl-1.0.2n" ];then
        tar -zxvf openssl-1.0.2n.tar.gz -C $nginx_install_dir/
        cd $nginx_install_dir/openssl-1.0.2n && ./config && make && make install
   fi
   #install nginx
   groupadd apache &&  useradd -g apache -s /sbin/nologin apache
   version="1.18.0"
   nginx_package="nginx-$version.tar.gz"
   nginx_download_url="https://nginx.org/download/$nginx_package"
   if [ ! -f "$nginx_package" ];then
       echo "beginnging download package of $nginx_package"
       wget $nginx_download_url
   fi
   if [ ! -d "$nginx_install_dir/nginx" ];then
        if [ ! -d "$installdir/nginx-$version" ];then
           tar -zxvf $nginx_package -C $installdir
        fi
        cd $installdir/nginx-$version && ./configure --prefix=$nginx_install_dir/nginx --with-cc-opt=-O2 --user=apache --group=apache --with-http_v2_module --with-http_sub_module --with-http_ssl_module --with-http_image_filter_module --with-http_gzip_static_module --with-http_v2_module --with-http_mp4_module --with-http_dav_module --with-http_flv_module --with-http_realip_module --with-http_stub_status_module --with-openssl=$nginx_install_dir/openssl-1.0.2n && make && make install
        ln -snf $nginx_install_dir/nginx/sbin/nginx /usr/sbin/
        mkdir $nginx_install_dir/nginx/conf/vhost
        yes |cp -i $installdir/nginx.conf $nginx_install_dir/nginx/conf/
        yes |cp -i $installdir/nginx /etc/init.d/
        sed -i -e "s#\/data\/software#$nginx_install_dir#" /etc/init.d/nginx
        chmod +x /etc/init.d/nginx
        echo "nginx$version is install compelet"
        echo "You can execute  /etc/init.d/nginx start to run it"
   else
       echo "安装目录$nginx_install_dir/nginx已存在,退出安装"
   fi
}


install_package
install_nginx
