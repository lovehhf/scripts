#!/bin/sh

function check_is_root(){
    if [ $EUID -ne 0 ]
      then
        echo "this script must run as root!"  1>&2
        exit 1
    fi
}

function check_os(){
    if [ -s /etc/redhat-release ]
      then
        OS=CentOS
      else
        echo "this script must run in Centos"
        exit
    fi
}

function disable_selinux(){
    if [ -s /etc/selinux/config ] && grep "SELINUX=enforcing" /etc/selinux/config >/dev/null 2>&1;
      then
        sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
        setenforce 0
    fi
}

function pre_install(){
    if [ "$OS" == "CentOS" ]
      then
        yum -y install  wget make openssl gcc-c++ ppp pptpd iptables iptables-services
    fi
}

function install_pptp(){
    check_os
    check_is_root
    disable_selinux

}
