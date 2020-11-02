# Azure WebApp for Container 向け CentOS 7.8 と PHP7.3+PHP-FPM Dockerfile

Azure WebApp for Containerで稼働するCentOS 7.8 with epel/remi ベース / Apache 2.4 / PHP 7.3 Remi FPM環境です。SSHでのAzureポータルからのログインも有効化しています。

## 開発環境
私の環境では、Cent OS7.8のVMにDockerをインストールしたものになっています。
導入されていない方は、yumで導入してください。

## リポジトリのクローン

```
git clone https://github.com/kazumihirose/AzWebAppConCent7.8PHPApache.git
```

## Docker イメージの作成と作成の確認
適当なタグをつけて、イメージをビルドしてください。

```
$ cd AzWebAppConCent7.8PHPApache
$ docker build --tag azwebapp_centos7_apache24event_remi_php73fpm_ssh .

$ docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
azwebapp_centos7_apache24event_remi_php73fpm_ssh             latest              4e6d858b3c79        3 hours ago         522MB
```

## Docker イメージを Azure Container Registry へPush する

[チュートリアル:カスタム イメージを作成し、プライベート レジストリから App Service 内で実行する](https://docs.microsoft.com/ja-jp/azure/app-service/containers/tutorial-custom-docker-image#deploy-app-to-azure)
の**アプリを Azure にデプロイする**からApp ServiceへContainerへPushしてください。

Azure Container RegistryにPushすれば、AzureポータルからWebApp for Containerを作成し、Azure Container RegistryのDockerイメージを指定するだけです。
手順では、azコマンドを使った作成で行っています。
(これらのコマンド操作を行う前に、事前にログイン az login と az account set --subscription サブスクリプション名でのログインを忘れないでください。)

## Dockerファイルのカスタマイズ

コードや拡張などを導入したい場合もあるでしょう、その場合はDockerfileから任意に弄ってください。GitやSSHなども含まれていますので、ある程度コンテナ内での動作を確認したうえでカスタマイズすると良いでしょう。
