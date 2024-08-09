今回の学習に当たり、**AWS EC2** という仮想サーバを使って、ご自身の PC の中に学習環境を構築しましょう。

以下を前提とします。

- AWS アカウントを作成していること
- PC に VSCode をインストールし、日本語パックをインストールしていること

## AWS CLI のインストール

`AWS CLI(Command Line Interface)` は、Amazon Web Services（AWS）が提供するコマンドラインツールであり、AWS のさまざまなサービスをコマンドラインから直接操作できるようにするものです。AWS CLI を使用することで、スクリプトを作成して AWS リソースを管理したり、AWS サービスを自動化したりすることができます。

以下の公式サイトの従って、AWS CLI をインストールします。

[AWS CLI インストールと更新の手順](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)

### Windows の場合

コマンドプロンプトを開き、以下のコマンドを実行します。

```bash:コマンドプロンプトでの実行コマンド
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```

### Mac の場合

ターミナルを開き、以下のコマンドを実行します。

```bash:ターミナルでの実行コマンド
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

## AWS EC2 インスタンスの作成

AWS にログインすると、以下のように AWS コンソールが開きます。
[![Image from Gyazo](https://i.gyazo.com/cfed6a9fc0c549048f857f40c1ddca4d.png)](https://gyazo.com/cfed6a9fc0c549048f857f40c1ddca4d)

右上の以下の箇所が `東京` になっているか確認し、なっていない場合は `東京` に変更します。
[![Image from Gyazo](https://i.gyazo.com/b58ef12c42c15adb9b93e8172470ac50.png)](https://gyazo.com/b58ef12c42c15adb9b93e8172470ac50)

左上の検索ボックスに `EC2` と入力してエンターキーを押します。
[![Image from Gyazo](https://i.gyazo.com/82c62511a7eb7c8c6e19f780b574f07a.png)](https://gyazo.com/82c62511a7eb7c8c6e19f780b574f07a)

以下のように EC2 ダッシュボードが開きます。
[![Image from Gyazo](https://i.gyazo.com/e4771f462ef0e0bfaa5da7631c240493.png)](https://gyazo.com/e4771f462ef0e0bfaa5da7631c240493)

次に `インスタンスを起動` ボタンをクリックします。

[![Image from Gyazo](https://i.gyazo.com/f35a5a76c921974b40cbb9101a9d2326.png)](https://gyazo.com/f35a5a76c921974b40cbb9101a9d2326)

`Launch an instance` の画面が開きます。

名前とタグの入力欄に `techboost` と入力します。
[![Image from Gyazo](https://i.gyazo.com/4583cb4ddedc757a253d870152af36c6.png)](https://gyazo.com/4583cb4ddedc757a253d870152af36c6)

Amazon マシンイメージ(AMI) の選択肢で `Amazon Linux 2 AMI(HVM)- Kernel 5.1.10, SSD Volune Type`を選択します。間違えると課金されるので注意深く選びましょう。
[![Image from Gyazo](https://i.gyazo.com/8861f392c0f7b249421d52a9f7e45868.png)](https://gyazo.com/8861f392c0f7b249421d52a9f7e45868)

キーペアの項目で、`新しいキーペアの作成` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/d1d633fe541e5b5996bfbd44b0867d08.png)](https://gyazo.com/d1d633fe541e5b5996bfbd44b0867d08)

キーペアを作成のダイアログで、キーペア名に `techboost` を入力し `キーペアを作成` ボタンを押します。
[![Image from Gyazo](https://i.gyazo.com/6f0064311b5db7c8314fca6d3879c6cc.png)](https://gyazo.com/6f0064311b5db7c8314fca6d3879c6cc)

`techboost.pem` という名前のファイル（秘密鍵）をどこにダウンロードするか聞いてきますので、**Windows の場合は C ドライブの直下**、**Mac の場合は、ダウンロードフォルダ** に保存します。

[![Image from Gyazo](https://i.gyazo.com/8c361c1fcc24af36e875fa10c7bf0c88.png)](https://gyazo.com/8c361c1fcc24af36e875fa10c7bf0c88)

さきほどの `Launch an instance` 画面に戻り、ネットワーク設定の箇所で

- `インターネットからのHTTPSトラフィックを許可`
- `インターネットからのHTTPトラフィックを許可`

にチェックを入れます。

[![Image from Gyazo](https://i.gyazo.com/826502411459d3073f879c01bab20cdc.png)](https://gyazo.com/826502411459d3073f879c01bab20cdc)

最後に `インスタンスを起動` ボタンを押します。

[![Image from Gyazo](https://i.gyazo.com/744d55c38e7c4db4ee4853519ae92e18.png)](https://gyazo.com/744d55c38e7c4db4ee4853519ae92e18)

以下の画面が開きますので、`インスタンスに接続` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/7ae70d3b4596d28b850854e946e0eef7.png)](https://gyazo.com/7ae70d3b4596d28b850854e946e0eef7)

SSH クライアントタブが開きます。
[![Image from Gyazo](https://i.gyazo.com/3917d4f4f8552fb0b67b15d036751c7a.png)](https://gyazo.com/3917d4f4f8552fb0b67b15d036751c7a)

以下の　`パブリックDNS`（人によって文字列が異なる） は後程使いますので、この画面は開いたままにしてください。
[![Image from Gyazo](https://i.gyazo.com/9751601c2d700d25df41950879f5cbb7.png)](https://gyazo.com/9751601c2d700d25df41950879f5cbb7)

ここまでで EC2 インスタンスの作成が終わりました。

## PC から EC2 インスタンスに SSH 接続する

**-- 以下場合分け開始 --**

**WIndows の場合**

管理者権限で `PowerShell` を開きます。

[![Image from Gyazo](https://i.gyazo.com/a8dd19ce16d3181374e4baf28c2e9e77.png)](https://gyazo.com/a8dd19ce16d3181374e4baf28c2e9e77)

`このアプリがデバイスに変更を加えることを許可しますか？` というダイアログが表示されたら `はい` ボタンをクリックします。

PowerShell で以下のコマンドを順に実行し、キーペアファイルのパーミッションを変更します。

```bash:PowerShellでの実行コマンド
icacls "C:\techboost.pem" /inheritance:r
icacls "C:\techboost.pem" /grant:r "${env:USERNAME}:(R)"
takeown /f "C:\techboost.pem"
```

以下が実行結果例です。
[![Image from Gyazo](https://i.gyazo.com/2b29ab1bc9d3d4fbc10a60772fb473b6.png)](https://gyazo.com/2b29ab1bc9d3d4fbc10a60772fb473b6)

続いて、PowerShell で以下のコマンドを実行します。
`パブリックDNS` の箇所は、さきほど開いていた `インスタンスに接続` タブで表示されていたご自身のものにすり替えて実行します。

```bash:PowerShellでの実行コマンド
ssh -i "C:\techboost.pem" ec2-user@パブリックDNS
```

パブリック DNS の前の `ec2-user@`という文字列は忘れないようにしましょう。

すると以下のように聞いてきますので、`yes`と入力して エンターキーを押します。
[![Image from Gyazo](https://i.gyazo.com/f54385cdf3498abdd902d906e5733c82.png)](https://gyazo.com/f54385cdf3498abdd902d906e5733c82)

以下のように `[ec2-user@ip-プライベートIPv4アドレス ~]$` というプロンプトが表示されれば、**PC から EC2 インスタンスの SSH 接続は成功しています**。`ip-プライベートIPv4アドレス`の文字列は人によって違います。
[![Image from Gyazo](https://i.gyazo.com/f1a0035000130449ed3a7f5f46924eb4.png)](https://gyazo.com/f1a0035000130449ed3a7f5f46924eb4)

確認したら、`[ec2-user@ip-プライベートIPv4アドレス ~]$`の後に `exit`と入力しエンターキーを押します。
もとの PowerShell のプロンプトに戻ります。
[![Image from Gyazo](https://i.gyazo.com/0602f7469ea934706c418810d156b2c0.png)](https://gyazo.com/0602f7469ea934706c418810d156b2c0)

PowerShell は終了しておきましょう。

### **Mac の場合**

ターミナルを開きます。

ターミナルで以下のコマンドを実行して、ダウンロードしたキーペアファイルのパーミッションを変更します。

```bash:ターミナルでの実行コマンド
chmod 400 ~/Downloads/techboost.pem
```

続いて以下のコマンドを実行します。`パブリックDNS` の部分を、先ほどメモした値に置き換えます。
パブリック DNS の前の `ec2-user@`という文字列は忘れないようにしましょう。

```bash:ターミナルでの実行コマンド
ssh -i ~/Downloads/techboost.pem ec2-user@パブリックDNS
```

初回接続時に、`yes` と入力して接続を続行します。

**接続が成功すると、`[ec2-user@ip-プライベートIPv4アドレス ~]$` というプロンプトが表示されます**s。

ターミナルで以下のコマンドを実行したあと、ターミナルを閉じます。

```bash:ターミナルでの実行コマンド
exit
```

**-- 場合分けここまで --**

## VSCode から Remote-SSH を利用して EC2 インスタンスに接続する

次に VSCode を起動し、左下の ⚙ のアイコンをクリックします。
[![Image from Gyazo](https://i.gyazo.com/b98f1967057b63d55817bf3ac3d8c00c.png)](https://gyazo.com/b98f1967057b63d55817bf3ac3d8c00c)

`拡張機能` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/02e048d613f328d690dc4d6aa3c6acc1.png)](https://gyazo.com/02e048d613f328d690dc4d6aa3c6acc1)

拡張機能: マーケットプレース の 検索ボックスに `SSH` と入力すると、`Remote - SSH` という拡張機能が表示されますので、`インストール` ボタンを押します。
[![Image from Gyazo](https://i.gyazo.com/7149130466b2e0f4b3bc118e7a92af14.png)](https://gyazo.com/7149130466b2e0f4b3bc118e7a92af14)

インストールが終わったら、以下のパソコンのモニターのアイコンをクリックして、リモート エキスプローラを開きます。
[![Image from Gyazo](https://i.gyazo.com/51a47bbf2178579bb6f82bf5ac5c76dd.png)](https://gyazo.com/51a47bbf2178579bb6f82bf5ac5c76dd)

REMOTES(TUNNELS/SSH) の `SSH` 項目の右端の ⚙ アイコンをクリックします。
[![Image from Gyazo](https://i.gyazo.com/b59796fb60633c0fa296478411c91720.png)](https://gyazo.com/b59796fb60633c0fa296478411c91720)

**-- 以下場合分け開始 --**

### **Windows の場合**

上部検索ボックスに表示される `C:\Users\ログインしているWindowsのユーザ名\.ssh\config` ファイルをクリックします。
[![Image from Gyazo](https://i.gyazo.com/410bd935e52ed74593ad5df0050be428.png)](https://gyazo.com/410bd935e52ed74593ad5df0050be428)

VSCode で config ファイルが開きます。
[![Image from Gyazo](https://i.gyazo.com/06c6f69d6c46256a0d6efff2fa67f5a4.png)](https://gyazo.com/06c6f69d6c46256a0d6efff2fa67f5a4)

config ファイルに以下を記述して上書き保存します。ただし、パブリック DNS の 場所はご自身固有の値に置き換えてください。

```yml:.ssh\config
Host TECHBOOST
  HostName パブリックDNS
  IdentityFile C:\techboost.pem
  User ec2-user
```

### **Mac の場合**

上部検索ボックスに表示される `~/.ssh/config` ファイルクリックします。

VSCode で `~/.ssh/config` ファイルが開きます。
このファイルに以下の内容を追加し、上書き保存します。ただし、パブリック DNS の 場所はご自身固有の値に置き換えてください。

```yaml:~/.ssh/config
Host TECHBOOST
  HostName パブリックDNS
  IdentityFile ~/Downloads/techboost.pem
  User ec2-user
```

**-- 場合分けここまで --**

次に、VSCode 左下の ⚙ アイコンを再度クリックして、コマンドパレットを開きます。
[![Image from Gyazo](https://i.gyazo.com/6c54789f9523845d2c4880021e18383d.png)](https://gyazo.com/6c54789f9523845d2c4880021e18383d)

VSCode 上部の検索ボックスに `Preferences: Open Settings (JSON)` を入力し、`基本設定: ユーザー設定を開く(JSON)`をクリックします。
[![Image from Gyazo](https://i.gyazo.com/bd5a32d01467dfb5a95087a0f1e82afc.png)](https://gyazo.com/bd5a32d01467dfb5a95087a0f1e82afc)

`settings.json` というファイルが開きます。表示内容は、個人差があります。
[![Image from Gyazo](https://i.gyazo.com/b99fb1aa9b51b21cd3fa1309954a996c.png)](https://gyazo.com/b99fb1aa9b51b21cd3fa1309954a996c)

**-- 以下場合分け開始 --**

### **Windows の場合**

1 行目の `{` の下に以下の 2 行を追記し上書き保存します。ログインしている Windows のユーザ名は、さきほどの値に置き換えてください。

```json:settings.json
    "remote.SSH.path": "C:\\Windows\\System32\\OpenSSH\\ssh.exe",
    "remote.SSH.configFile": "C:\\Users\\ログインしているWindowsのユーザ名\\.ssh\\config",
```

[![Image from Gyazo](https://i.gyazo.com/136fb9fa040f16af9405f727cd90134e.png)](https://gyazo.com/136fb9fa040f16af9405f727cd90134e)

### **Mac の場合**

1 行目の `{` の下に以下の 1 行を追記し上書き保存します。

```json:settings.json
    "remote.SSH.configFile": "~/.ssh/config"
```

**-- 場合分けここまで --**

最後に VSCode の左下の 青色 アイコンをクリックします。
[![Image from Gyazo](https://i.gyazo.com/8ef10ec581e1d9998ad66084d5d9ab93.png)](https://gyazo.com/8ef10ec581e1d9998ad66084d5d9ab93)

VSCode 上部に開いた検索ボックスで、`ホストの接続する...` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/edb4a332248e5b3c05a8c664535ac136.png)](https://gyazo.com/edb4a332248e5b3c05a8c664535ac136)

`TECHBOOST` というホストをクリックします。
[![Image from Gyazo](https://i.gyazo.com/61ddc1cce9d6356235461ab22a16facf.png)](https://gyazo.com/61ddc1cce9d6356235461ab22a16facf)

新たに起動した VSCode 画面で、`Linux` を選択します。
[![Image from Gyazo](https://i.gyazo.com/3c8168b21530d4d13c54b88d09e6940e.png)](https://gyazo.com/3c8168b21530d4d13c54b88d09e6940e)

以下のダイアログが表示された場合、`今後は表示しない` にチェックを入れ、`許可` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/72e115cd188e496eab86420ad4131e12.png)](https://gyazo.com/72e115cd188e496eab86420ad4131e12)

以下のような表示になります。
[![Image from Gyazo](https://i.gyazo.com/cc9efd25c67113c38a61e495991fae9b.png)](https://gyazo.com/cc9efd25c67113c38a61e495991fae9b)

上部の `ターミナル` メニューをクリックし `新しいターミナル` を選択します。
[![Image from Gyazo](https://i.gyazo.com/1bf3e06adbad5c40fac7026556d560e6.png)](https://gyazo.com/1bf3e06adbad5c40fac7026556d560e6)

画面下記にターミナルが起動します。
[![Image from Gyazo](https://i.gyazo.com/7b6465f8726321fa9915b022b8e6ded7.png)](https://gyazo.com/7b6465f8726321fa9915b022b8e6ded7)

このターミナルで以下のコマンドを実行します。

```bash:ターミナルで実行するコマンド
mkdir environment
cd environment/
```

[![Image from Gyazo](https://i.gyazo.com/01ec2e0ca9f1f21e8c181d7cb0bdacb6.png)](https://gyazo.com/01ec2e0ca9f1f21e8c181d7cb0bdacb6)

次に、新たに起動した VSCode 画面左上の以下のアイコンをクリックしてエキスプローラを開きます。
[![Image from Gyazo](https://i.gyazo.com/ea870e53f416a391cccc60d8288d22b7.png)](https://gyazo.com/ea870e53f416a391cccc60d8288d22b7)

`フォルダを開く` ボタンをクリックします。
[![Image from Gyazo](https://i.gyazo.com/dc7bfe8b6569a7f41a2310dab0d2359d.png)](https://gyazo.com/dc7bfe8b6569a7f41a2310dab0d2359d)

`environment` の行を選択し OK をクリックします。
[![Image from Gyazo](https://i.gyazo.com/0a7ec2fdd0230c9730d6ba39f864ed7a.png)](https://gyazo.com/0a7ec2fdd0230c9730d6ba39f864ed7a)

VSCode が再起動しますので、Linux を選択します。
[![Image from Gyazo](https://i.gyazo.com/31df2fd2141131f22c0cf6c548f95573.png)](https://gyazo.com/31df2fd2141131f22c0cf6c548f95573)

以下のダイアログが表示されますので、`親フォルダー 'home' 内のすべてのファイルの作成者を信頼します`　にチェックを入れ、`はい、作成者を信頼します` ボタンを押します。
[![Image from Gyazo](https://i.gyazo.com/d16322603ff97f88b758baf87c1354fb.png)](https://gyazo.com/d16322603ff97f88b758baf87c1354fb)

以下のような画面表示になります。
[![Image from Gyazo](https://i.gyazo.com/5d88719123f97a7521d3ed6eb9f3b8e6.png)](https://gyazo.com/5d88719123f97a7521d3ed6eb9f3b8e6)

ここまでで、**VSCode から EC2 インスタンスに SSH 接続することに成功しました**。

## 環境の設定と、各種アプリのインストール

### PHP コース、Ruby コースの場合

続いて、新しく開いた VSCode のターミナルで以下のコマンドで次のスクリプトを実行します。

```sh
#!/bin/bash

# キャッシュメモリ を解放
#sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

# swap領域 を拡張
sudo dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo chmod 600 /var/swap.1
sudo mkswap /var/swap.1
sudo swapon /var/swap.1
sudo cp -p /etc/fstab /etc/fstab.ORG
sudo sh -c "echo '/var/swap.1 swap swap defaults 0 0' >> /etc/fstab"

# パッケージ情報の更新
sudo yum update -y

# 必要なツールとライブラリのインストール
sudo yum install -y git bzip2 libffi-devel amazon-linux-extras curl

# 開発ツールのインストール（主要な開発ライブラリを含む）
sudo yum groupinstall -y "Development Tools"
sudo yum install -y openssl-devel readline-devel zlib-devel

# MariaDB のアンインストールと MySQL 5.7 のインストール
sudo service mariadb stop
sudo yum -y erase mariadb-config mariadb-common mariadb-libs mariadb
sudo yum -y localinstall https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum -y install mysql-community-server
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service
DB_PASSWORD=$(sudo grep "A temporary password is generated" /var/log/mysqld.log | sed -s 's/.*root@localhost: //')
mysql -uroot -p"${DB_PASSWORD}" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewSecurePassword123!'; uninstall plugin validate_password; set password for root@localhost=password('');"

# PostgreSQL 11 のインストール
sudo amazon-linux-extras install -y postgresql11
sudo yum -y install postgresql-devel

# rbenv のインストール
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# ruby-build のインストール
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Ruby 2.7.3 のインストール
rbenv install 2.7.3
rbenv global 2.7.3

# Rails 5.2.0 のインストール
gem install nokogiri -v 1.15.6
gem install rails -v 5.2.0

# Node.js のインストール
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

# Yarn のインストール
sudo npm install --global yarn

# PHP 8.0 のインストール
sudo yum remove -y php php-*
sudo amazon-linux-extras disable lamp-mariadb10.2-php7.2
sudo amazon-linux-extras install php8.0 -y
sudo amazon-linux-extras enable php8.0
sudo yum install php-mbstring php-pdo php-mysqlnd php-bcmath php-xml -y
sudo rm -f /etc/php.d/30-xdebug.ini

# composer のインストール
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer

# mysql2 gem のインストール
gem install mysql2 -v '0.5.5' --source 'https://rubygems.org/'
sudo yum install mysql-devel
# gem install mysql2 -v '0.5.5' -- --with-mysql-config=/usr/bin/mysql_config

# prompt.sh の設定
echo '#!/bin/sh' > /home/ec2-user/prompt.sh
echo 'parse_git_branch() {' >> /home/ec2-user/prompt.sh
echo '    git branch 2> /dev/null | sed -e '\''/^[^*]/d'\'' -e '\''s/* \(.*\)/ (\1)/'\''' >> /home/ec2-user/prompt.sh
echo '}' >> /home/ec2-user/prompt.sh
echo 'export PS1="\[\033[01;32m\]\u\[\033[00m\]:\[\033[34m\]\w\[\033[00m\]\$(parse_git_branch) $ "' >> /home/ec2-user/prompt.sh

sudo chmod 755 /home/ec2-user/prompt.sh
echo 'source ~/prompt.sh' >> /home/ec2-user/.bashrc
echo 'source ~/prompt.sh' >> /home/ec2-user/.bash_profile

# シェルの設定を再読み込み
source ~/.bashrc
source ~/.bash_profile
```

### Java コースの AWS デプロイ

テキスト通り、Remote-SSH 接続した VSCode のターミナルで以下のコマンドを実行する。

```bash:ターミナルでの実行コマンド
curl -sS https://raw.githubusercontent.com/techboost-curriculum-updaters-new/scripts/master/java/java-setup.sh | sh; exec $SHELL -l
```

インバウンドルールの SSH は消さない。HTTP, HTTPS の設定はテキスト通り。
