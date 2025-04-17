# 概要
今年に入り、 **<span style="color:red;">VSCodeから AWS EC2インスタンスに SSH接続する際に、接続に失敗する現象が発生していることを確認しています。</span>**
学習にお不便をおかけし申し訳ございません。

以下のような外部サイトなども同じような症状を報告しています。

[VSCodeからSSH接続できなくなった対処](https://qiita.com/toim/items/6f2d03fc14710fc4e5d8)

**<span style="color:blue;">本資料では、不具合を解決する具体的な対処方法をお伝えします。</span>**

結果からお伝えすると、 **<span style="color:red;">VSCodeの最新バージョン 1.99 と EC2インスタンス（OS は Amazon Linux2）の相性が悪いため（具体的には VSCodeの最新版の glibs/libstdc++ というプログラムが EC2インスタンスと相性が悪いため）** です</span>。

このエラーの発生するパターンは、おおよそ以下の2つとなります。
- **パターン1** :  　
今まで VSCodeからEC2インスタンスに正常にSSH接続できていたが、突然接続できなくなった。
- **パターン2** : 　
 新しく受講を開始したばかりだが、[補足資料](https://github.com/techboost-curriculum-updaters-new/scripts/blob/master/about_ssh/EC2%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%81%ABVSCode%E3%81%8B%E3%82%89Remote-SSH%E6%8E%A5%E7%B6%9A%E3%81%99%E3%82%8B%E3%83%9E%E3%83%8B%E3%83%A5%E3%82%A2%E3%83%AB.md) に従って作業を進めると、VSCodeから EC2インスタンスにSSH接続できない。

エラー状況は、2パターン共通して以下となっているかと思います。
[![Image from Gyazo](https://i.gyazo.com/3a6c8b511ba9b3f33c7492124da9c68f.png)](https://gyazo.com/3a6c8b511ba9b3f33c7492124da9c68f)

この不具合を解決するためには、VSCodeのバージョンを、**最新の 1.99** から **1.98 にダウングレード** することが必要です。

# 解決の具体的な操作方法
## 1. 現状の VSCodeのバージョンを確認
上記のエラー画面が表示されたら、一旦以下の  **「リモート接続を閉じる」** ボタンを押してください。
[![Image from Gyazo](https://i.gyazo.com/7aa7234d51497e65e697f37e38846c06.png)](https://gyazo.com/7aa7234d51497e65e697f37e38846c06)

すると、以下のような表示に変わると思います。
[![Image from Gyazo](https://i.gyazo.com/db8d3c51162cc1c862b59761afb185a5.png)](https://gyazo.com/db8d3c51162cc1c862b59761afb185a5)

次に、**現在ご自身のPCにインストールしているVSCodeのバージョンを確認します** 。

<details>
  <summary>Windowsの場合</summary>

VSCode上部の  **「ヘルプメニュー」** から **「バージョン情報」** を選択してください。
[![Image from Gyazo](https://i.gyazo.com/e40c44f7ea8f41683df4e428585db488.png)](https://gyazo.com/e40c44f7ea8f41683df4e428585db488)
以下のように **VSCodeバージョンが 1.99系であることが確認できる** かと思います。
[![Image from Gyazo](https://i.gyazo.com/22c062d10b117546a2efb118898a7229.png)](https://gyazo.com/22c062d10b117546a2efb118898a7229)
</details>

<details>
  <summary>Macの場合</summary>
  
VSCode上部の  **「Codeメニュー」** から  **「Visual Stdio Code の バージョン情報」** を選択してください。
[![Image from Gyazo](https://i.gyazo.com/dec1f35a0a59b1c781c1e8cc7d7f7d1f.png)](https://gyazo.com/dec1f35a0a59b1c781c1e8cc7d7f7d1f)

以下のように **VSCodeバージョンが 1.99系であることが確認できる** かと思います。
[![Image from Gyazo](https://i.gyazo.com/7e433cb159e07b4d982b8b63832587dd.png)](https://gyazo.com/7e433cb159e07b4d982b8b63832587dd)
</details>

## 2. VSCodeの自動アップデート設定の解除
これから VSCodeを最新の 1.99系から1.98系にダウングレードしていきますが、**現状の VSCodeの設定では自動的に VSCodeが最新版にアップグレードされてしまう設定となっています**。

つまり 、これからの作業で VSCodeを 1.98にダウンロードしても、自動的に 1.99系にアップグレードされてしまうため、作業の意味がなくなってしまいます。

そのため、この自動アップグレード設定を解除します。

まずは、VSCode画面の左下の ⚙アイコンをクリックして、**「設定」** を選択してください。
[![Image from Gyazo](https://i.gyazo.com/f2b6a0363f7fb831a9c80e07831c0837.png)](https://gyazo.com/f2b6a0363f7fb831a9c80e07831c0837)

以下の設定画面が開きましたら、以下の画像の赤枠の検索ボックスに **<span style="color: red;">update: mode</span>** と入力します。コピペで構いません。
[![Image from Gyazo](https://i.gyazo.com/f89c4d7f7d637b408258d66a960d9156.png)](https://gyazo.com/f89c4d7f7d637b408258d66a960d9156)

**Update: Mode** の選択肢を **default** から **manual** に変更します。すると、VSCodeの再起動を促されますので、 **「再起動」** ボタンを押します、
[![Image from Gyazo](https://i.gyazo.com/3e36db4388905edf1cade04c673c6ef4.png)](https://gyazo.com/3e36db4388905edf1cade04c673c6ef4)

**<span style="color: red;">この段階で VSCodeアプリは一旦終了してください。</span>**

これで、VSCodeの自動アップデート設定が解除されました。

## 3. VSCode1.98 のインストール
以下のリンクをクリックして、VSCode1.98のインストーラのダウンロードページを開きます。

[VSCode 1.98 のインストーラ ダウンロードページ](https://code.visualstudio.com/updates/v1_98)

このページの以下のリンクをクリックして、**VSCode 1.98 のインストーラをご自身のPCにダウンロードします** 。 **<span style="color:red;">お使いのPCによって、クリックする場所が違いますのでご注意ください</span>** 。
[![Image from Gyazo](https://i.gyazo.com/de1c841ef8b803d354a25abdb55546a3.png)](https://gyazo.com/de1c841ef8b803d354a25abdb55546a3)

お使いのPCのデフォルト設定では、**ダウンロードフォルダにインストーラファイルがダウンロードされる** かと思います。そのアイコンをダブルクリックして、今までと同様に VSCodeをインストールし直します。

<details>
  <summary>Windowsの場合</summary>
  
[![Image from Gyazo](https://i.gyazo.com/71d1d7991cd03e93c54ba509ec14eff4.png)](https://gyazo.com/71d1d7991cd03e93c54ba509ec14eff4)

</details>

<details>
  <summary>Macの場合</summary>

[![Image from Gyazo](https://i.gyazo.com/40aebcccfcc5de2a7dc03da5e26d3461.png)](https://gyazo.com/40aebcccfcc5de2a7dc03da5e26d3461)

</details>

インストールが完了した時、以下のダイアログが表示される場合は、チェックをいれ **「完了」** ボタンを押してください。

[![Image from Gyazo](https://i.gyazo.com/5e6f6937ff05a8913d72e2bc00b8b99a.png)](https://gyazo.com/5e6f6937ff05a8913d72e2bc00b8b99a)

VSCodeが新たに起動します。

本資料の  [1. 現状の VSCodeのバージョンを確認](#1-現状の-vscodeのバージョンを確認) の作業と同様に、 VSCodeの現在のバージョンを確認してください。以下のように バージョンが1.98であればダウングレードできています。

<details>
  <summary>Windowsの場合</summary>
  
Windowsの場合
[![Image from Gyazo](https://i.gyazo.com/232b15d2cc759a7f3d82b652d037eecf.png)](https://gyazo.com/232b15d2cc759a7f3d82b652d037eecf)

</details>

<details>
  <summary>Macの場合</summary>
  
[![Image from Gyazo](https://i.gyazo.com/af279e36dd8e6517107ac1ebfbbdbd47.png)](https://gyazo.com/af279e36dd8e6517107ac1ebfbbdbd47)

</details>

## 4. VSCodeのバージョンを 1.98に固定する
本資料の [2. VSCodeの自動アップデート設定の解除](#2-vscodeの自動アップデート設定の解除) の作業に従って、以下の箇所を **manual** から **none** に変更して、VSCodeを再起動します。
[![Image from Gyazo](https://i.gyazo.com/e453be184fd09f4ae3e30ecae9c07951.png)](https://gyazo.com/e453be184fd09f4ae3e30ecae9c07951)

これで、VSCodeのバージョンが 1.98に固定されます。
## 5. VSCodeから EC2インスタンスに SSH接続する

VSCodeのバージョンが 1.98に変更され、そのバージョンが固定されていることが確認できたら、以下の[補足資料](https://github.com/techboost-curriculum-updaters-new/scripts/blob/master/about_ssh/EC2%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%81%ABVSCode%E3%81%8B%E3%82%89Remote-SSH%E6%8E%A5%E7%B6%9A%E3%81%99%E3%82%8B%E3%83%9E%E3%83%8B%E3%83%A5%E3%82%A2%E3%83%AB.md)の  **「VSCode から Remote-SSH を利用して EC2 インスタンスに接続する」** に従い VSCodeからEC2インスタンスに SSH接続すると成功するかと思います。

## 6. それでも解決しない場合
VSCodeの設定以前に  **「PC から EC2 インスタンスに SSH 接続する」** ことがうまくいっていない可能性があります。
さきほどの[補足資料](https://github.com/techboost-curriculum-updaters-new/scripts/blob/master/about_ssh/EC2%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%81%ABVSCode%E3%81%8B%E3%82%89Remote-SSH%E6%8E%A5%E7%B6%9A%E3%81%99%E3%82%8B%E3%83%9E%E3%83%8B%E3%83%A5%E3%82%A2%E3%83%AB.md)の 「PC から EC2 インスタンスに SSH 接続する」の作業までで間違いがないかご確認ください。
**<span style="color:red;">難しい場合は メンターにご相談いただくといいかと思います。</span>**