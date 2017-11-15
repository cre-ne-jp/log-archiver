#!/bin/bash -x

# Travis CIでMroongaをインストールするためのスクリプト
#
# 参考文献：
# 1. [Mroonga v7.08 documentation » 2.4. Ubuntu](http://mroonga.org/ja/docs/install/ubuntu.html)
# 2. [Install MySQL 5.7 on Travis-CI](https://gist.github.com/BenMorel/d981f25ead0926a0cb6d)

# Mroongaのインストールに必要なuniverseリポジトリと
# セキュリティアップデートリポジトリを有効にする
sudo apt-get install -y -V software-properties-common lsb-release
sudo add-apt-repository -y universe
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu $(lsb_release --short --codename)-security main restricted"

# ppa:groonga/ppa PPAをシステムに追加する
sudo add-apt-repository -y ppa:groonga/ppa
sudo apt-get update

# Travis CIのVMのUbuntu 14.04では、標準でMySQL 5.6がインストール
# されているが、これはMySQL 5.5ベースのmysql-server-mroongaと共存できない。
# そのため、最初にMySQL 5.6に関連したパッケージを除く。
sudo apt-get remove --purge "^mysql.*"
sudo apt-get autoremove
sudo apt-get autoclean
sudo rm -rf /var/{lib,log}/mysql

# Mroongaをインストールする
sudo apt-get install -y -V mysql-server-mroonga
sudo apt-get install -y -V libmysqlclient-dev
