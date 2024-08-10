# AWS EC2 に VSCode から SSH 接続した開発環境の構築

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

最後に、AWS CLIが正常にインストールされているか確認します。

コマンドプロンプトを再起動して、以下のコマンドを実行します。
```bash:コマンドプロンプトでの実行コマンド
aws --version
```

以下のように表示されればインストールが成功しています。`...`の箇所は環境により異なります。
```bash:コマンドプロンプトでの実行結果
aws-cli/2.... Python/3... Windows/...
```

### Mac の場合

ターミナルを開き、以下のコマンドを実行します。パスワードを聞いてきますので、Mac にログインする際のパスワードを入力してエンターキーを押します。

```bash:ターミナルでの実行コマンド
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

最後に、AWS CLIが正常にインストールされているか確認します。

ターミナルを再起動して、以下のコマンドを実行します。
```bash:ターミナルでの実行コマンド
aws --version
```

以下のように表示されればインストールが成功しています。`...`の箇所は環境により異なります。
```bash:ターミナルでの実行結果
aws-cli/2... Python/3... .../... exe/...
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

- Windows の場合
  [![Image from Gyazo](https://i.gyazo.com/8c361c1fcc24af36e875fa10c7bf0c88.png)](https://gyazo.com/8c361c1fcc24af36e875fa10c7bf0c88)
- Mac の場合
  [![Image from Gyazo](https://i.gyazo.com/8eddeb059280015dcbe7daa858811e66.png)](https://gyazo.com/8eddeb059280015dcbe7daa858811e66)

さきほどの `Launch an instance` 画面に戻り、ネットワーク設定の箇所で

- `インターネットからのHTTPSトラフィックを許可`
- `インターネットからのHTTPトラフィックを許可`

にチェックを入れます。

[![Image from Gyazo](https://i.gyazo.com/826502411459d3073f879c01bab20cdc.png)](https://gyazo.com/826502411459d3073f879c01bab20cdc)

ストレージを設定の箇所で `15`と入力します。
[![Image from Gyazo](https://i.gyazo.com/3a151c0fe9690b9583cfd6bff41eae16.png)](https://gyazo.com/3a151c0fe9690b9583cfd6bff41eae16)

最後に `インスタンスを起動` ボタンを押します。

[![Image from Gyazo](https://i.gyazo.com/744d55c38e7c4db4ee4853519ae92e18.png)](https://gyazo.com/744d55c38e7c4db4ee4853519ae92e18)

以下の画面が開きますので、`インスタンスに接続` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/7ae70d3b4596d28b850854e946e0eef7.png)](https://gyazo.com/7ae70d3b4596d28b850854e946e0eef7)

SSH クライアントタブを開きます。
[![Image from Gyazo](https://i.gyazo.com/3917d4f4f8552fb0b67b15d036751c7a.png)](https://gyazo.com/3917d4f4f8552fb0b67b15d036751c7a)

以下の　`パブリックDNS`（人によって文字列が異なる） は後程使いますので、この画面は開いたままにしてください。
[![Image from Gyazo](https://i.gyazo.com/9751601c2d700d25df41950879f5cbb7.png)](https://gyazo.com/9751601c2d700d25df41950879f5cbb7)

ここまでで EC2 インスタンスの作成が終わりました。

最後に EC2インスタンスが停止することを防ぐために、停止保護設定をします。
以下の画面で、`インスタンス` のリンクをクリックします。
[![Image from Gyazo](https://i.gyazo.com/9d102e8a480e3dabc7af199fc4069154.png)](https://gyazo.com/9d102e8a480e3dabc7af199fc4069154)

次に 以下の手順で `停止保護` を選択します。
[![Image from Gyazo](https://i.gyazo.com/16b1fc58231436348d0821d44692fb32.png)](https://gyazo.com/16b1fc58231436348d0821d44692fb32)

有効化にチェックを入れ、`保存` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/25aab099bd010e5701bd7290932208d9.png)](https://gyazo.com/25aab099bd010e5701bd7290932208d9)

以上で、EC2インスタンスの作成と停止保護の設定が完了しました。

## PC から EC2 インスタンスに SSH 接続する

**-- 以下場合分け開始 --**

### **Windows の場合**

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

以下のようなダイアログが表示されたら`OK`をクリックします。
[![Image from Gyazo](https://i.gyazo.com/c1152ef1a229d69fa11bfc8ffe3ce476.png)](https://gyazo.com/c1152ef1a229d69fa11bfc8ffe3ce476)

続いて以下のコマンドを実行します。`パブリックDNS` の部分を、先ほどメモした値に置き換えます。
パブリック DNS の前の `ec2-user@`という文字列は忘れないようにしましょう。

```bash:ターミナルでの実行コマンド
ssh -i ~/Downloads/techboost.pem ec2-user@パブリックDNS
```

初回接続時に、`yes` と入力して接続を続行します。
[![Image from Gyazo](https://i.gyazo.com/9c3283fddeece69e96ad7c124886e382.png)](https://gyazo.com/9c3283fddeece69e96ad7c124886e382)

**接続が成功すると、`[ec2-user@ip-プライベートIPv4アドレス ~]$` というプロンプトが表示されます**。
[![Image from Gyazo](https://i.gyazo.com/33eec4f2acd8f33eb823aaa631e7fa5e.png)](https://gyazo.com/33eec4f2acd8f33eb823aaa631e7fa5e)
ターミナルで以下のコマンドを実行したあと、ターミナルを閉じます。

```bash:ターミナルでの実行コマンド
exit
```

[![Image from Gyazo](https://i.gyazo.com/ae8a14ae4ca9d080dc8827e6e24d25e0.jpg)](https://gyazo.com/ae8a14ae4ca9d080dc8827e6e24d25e0)

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
[![Image from Gyazo](https://i.gyazo.com/0484520d49126d53918444402214db3f.png)](https://gyazo.com/0484520d49126d53918444402214db3f)

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

上部検索ボックスに表示される `Users/ユーザー名/.ssh/config` ファイルクリックします。
[![Image from Gyazo](https://i.gyazo.com/2dd09cefe17456d788ff2e21c4d47786.png)](https://gyazo.com/2dd09cefe17456d788ff2e21c4d47786)

VSCode で `Users/ユーザー名/.ssh/config` ファイルが開きます。
このファイルに以下の内容を追加し、上書き保存します。ただし、パブリック DNS の 場所はご自身固有の値に置き換えてください。

```yml:Users/ユーザー名/.ssh/config
Host TECHBOOST
  HostName パブリックDNS
  IdentityFile ~/Downloads/techboost.pem
  User ec2-user
```

保存する際に以下のようなダイアログが表示された場合は、`Sudo権限で再試行...` をクリックしてください。Mac にログインする際のパスワードを聞いてきますので入力して上書き保存してください。
[![Image from Gyazo](https://i.gyazo.com/a5559da394c05283455d82cd9339ab60.png)](https://gyazo.com/a5559da394c05283455d82cd9339ab60)

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

Mac の場合、以下のようなダイアログが表示された時は `OK` をクリックします。
[![Image from Gyazo](https://i.gyazo.com/c6b689c4ec356c41c804cf9ac3bb6145.png)](https://gyazo.com/c6b689c4ec356c41c804cf9ac3bb6145)

Window の場合は、新たに起動した VSCode 画面で、`Linux` を選択します。
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

VSCode が再起動しますので、Window の場合は `Linux` を選択します。
[![Image from Gyazo](https://i.gyazo.com/31df2fd2141131f22c0cf6c548f95573.png)](https://gyazo.com/31df2fd2141131f22c0cf6c548f95573)

以下のダイアログが表示されますので、`親フォルダー 'home' 内のすべてのファイルの作成者を信頼します`　にチェックを入れ、`はい、作成者を信頼します` ボタンを押します。
[![Image from Gyazo](https://i.gyazo.com/d16322603ff97f88b758baf87c1354fb.png)](https://gyazo.com/d16322603ff97f88b758baf87c1354fb)

以下のような画面表示になります。
[![Image from Gyazo](https://i.gyazo.com/5d88719123f97a7521d3ed6eb9f3b8e6.png)](https://gyazo.com/5d88719123f97a7521d3ed6eb9f3b8e6)

ここまでで、**VSCode から EC2 インスタンスに SSH 接続することに成功しました**。

最後に、Remote-SSHで EC2インスタンスの接続した場合に、毎回同じ画面が表示されるように設定します。

新しく起動したVSCodeの左下の以下の **⚙** アイコンをクリックし、**コマンドパレット** を選択してください。
[![Image from Gyazo](https://i.gyazo.com/7f683e2c4c0c310b43a70295aa0b5d0a.png)](https://gyazo.com/7f683e2c4c0c310b43a70295aa0b5d0a)

上部の検索ボックスに **Open Container Configuration File** と入力し、選択肢に出てくる **開発コンテナー: コンテナ―構成ファイルを開く** メニューをクリックしてください。
[![Image from Gyazo](https://i.gyazo.com/d357e423a050c80ef54f88bba0fa11c9.png)](https://gyazo.com/d357e423a050c80ef54f88bba0fa11c9)

以下のように **dmm_webcamp-web.json** という名前のファイルが開きます。
2行目から4行目の記述は、お使いのPC環境によって違う場合があります。
[![Image from Gyazo](https://i.gyazo.com/5e18450e1707619d1472d96623111eea.png)](https://gyazo.com/5e18450e1707619d1472d96623111eea)

**dmm_webcamp-web.json** ファイルの 最終行の `}` 行の1行上に以下の2行のコードを追記します。
```js:dmm_webcamp-web.json
	"remoteUser": "ec2-user",
	"workspaceFolder": "/home/ec2-user/environment"
```

以下が最終形の **dmm_webcamp-web.json** ファイルの様子です。上書き保存をしておきましょう。
[![Image from Gyazo](https://i.gyazo.com/2fb6c794b8fb3268c2190d1765b9cacf.png)](https://gyazo.com/2fb6c794b8fb3268c2190d1765b9cacf)


## 環境の設定と、各種アプリのインストール

### PHP コース、Ruby コースの場合

続いて、新しく開いた VSCode のターミナルで以下のコマンドで次のスクリプトを実行します。

```bash:ターミナルでの実行コマンド
curl -sSL https://raw.githubusercontent.com/techboost-curriculum-updaters-new/scripts/master/about_ssh/setup.sh | sh; exec $SHELL -l
```

### Java コースの AWS デプロイ

テキスト通り、Remote-SSH 接続した VSCode のターミナルで以下のコマンドを実行する。

```bash:ターミナルでの実行コマンド
curl -sS https://raw.githubusercontent.com/techboost-curriculum-updaters-new/scripts/master/java/java-setup.sh | sh; exec $SHELL -l
```

**注) インバウンドルールの SSH は消さない。HTTP, HTTPS のインバウンドルールの設定はテキスト通り。**
