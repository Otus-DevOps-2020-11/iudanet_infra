# iudanet_infra

iudanet Infra repository

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
