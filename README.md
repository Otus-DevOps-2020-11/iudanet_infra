# iudanet_infra

iudanet Infra repository

## HW-8

* После выполнения команды удаления папки, запуск плейбука будет в статусе `change` так как Ansible создал папку и склонировал в нее репозиторий.

```txt
Теперь выполните ansible app -m command -a 'rm -rf~/reddit'  и  проверьте  еще  раз  выполнение  плейбука.
Чтоизменилось и почему? Добавьте информацию в README.md.
```

* Написан скрипт Dynamic Inventory

## HW-7

* Создал модули terraform для app, db и vpc(не используется)
* Создал 2 окружения, prod и stage

* Для создания  бакенда terraform с использованием s3 нужно создать 2 ресурса.
  * создаем ключ для s3 бакета и записваем его в файл ```~/.aws/credentials ```

  ```txt
  [default]
  aws_access_key_id=blablabla
  aws_secret_access_key=supersecretblablabla
  ```

  * разворачиваем s3 бакет

  ```bash
  cd terraform
  terraform init
  terraform apply
  ```

  * Базу для локов создавать в ресурсе Yandex Database. Ресурса для терраформа еще нет, так что нужно создавать базу и таблицу руками в консоли
  * Создаем базу Serverless получаем ссылку на эндпоинт
  * Создаем таблицу. Тип "Документная таблица", имя любое любимое, 1 колонка "LockID" с типом String, галочка на ключе партицирования

* для запуска provisioner используется переменная ```run_provisioner```, реализовано через ```null_resource``` и условный count
* Провижинг настраивает переменную среды c адресом mongodb через темплейт для app
* mongodb настраивается на прием по ```0.0.0.0```. ***ВНИМАНИЕ СВОБОДНЫЙ ДОСТУП ИЗ ИНТЕРНЕТА к БАЗЕ!!!***
* После проверки сразу удалять проект!

  ```bash
  terraform destroy
  ```

## HW-6

* Установлен terraform
* Создан проект terraform с описанием инфраструктуры:
  * используется балансировщик нагрузки
  * Таргет группа на виртуальные машины для балансировщика
  * виртуальная машина создается из подготовленного Packer образа
  * есть возможность через переменные задавать количество запускаемых виртуальных машин
  * виртуальная машина дополнительно настраивается с помощью bash скрипта
* Так как копировать код для развертывания нескольких одинаковых VM не удобно, использован параметр ресурса ```count```.

### Проверка проекта

```bash
cd terraform
terraform init
terraform plan
```

* Запуск проекта

```bash
terraform apply
```

* Остановка проекта

```bash
terraform destroy
```

## HW-5

* Установлен packer на локальную машину
* Создан сервистный аккаунт и ключ для него

```bash
yc iam service-account create --name otus-auto --folder-id=$FOLDER_ID
yc resource-manager folder add-access-binding --id=$FOLDER_ID --role=editor --service-account-id=$SA_ID
yc iam key create --service-account-id=$SA_ID --output=/home/otus/yandex-cloud/otus-auto.key.json
```

* Создан темплейт для создания образа виртуальной машины через packer

```bash
cd packer
# Настроим переменные
mv variables.json.example variables.json
# правка variables.json
vim variables.json
#Запуск сборки базового образа
packer build -var-file variables.json ubuntu16.json

#Запуск сборки образа с приложение
packer build -var-file variables.json immutable.json
```

* Написан скрипт запуска виртуальной машины "запеченной" с приложением

```bash
./config-scripts/create-reddit-vm.sh
```

* поиск стандартный образов

```bash
yc compute image list --folder-id standard-images
```

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
  --memory=2GB \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=otus-net-ru-central1-a,nat-ip-version=ipv4 \
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
