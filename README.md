# iudanet_infra

iudanet Infra repository

## HW-4

```txt
testapp_IP=178.154.224.22
testapp_port=9292
```

### Запуск инстанса

```bash
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=metadata.yaml
```

## IP адреса VPS

```txt
bastion_IP = 178.154.230.170
someinternalhost_IP = 10.130.0.12
```

## Подключение по ssh через Jump host

Напрямую подключиться к приватному ```someinternalhost``` серверу можно через Jump хост ```bastion```

Пример команды:

```bash
ssh -i ~/.ssh/appuser -J appuser@$bastion_IP appuser@$someinternalhost_IP
```

Для упрощения подключения в будущем, можно добавить в ```~/.ssh/config``` :

```txt
Host 10.130.0.*
    ProxyJump appuser@$bastion_IP
    User appuser
    IdentityFile ~/.ssh/appuser
```

и подключаться по приватному IP сервера

```bash
ssh $someinternalhost_IP
```

## Подключение по ssh через VPN

* На bastion выполнить

```bash
sudo bash setupvpn.sh
```

* настроить сервер pritunl через браузер.

```bash
https://$bastion_IP/setup
```

* подключиться с помошью файла *.ovpn
