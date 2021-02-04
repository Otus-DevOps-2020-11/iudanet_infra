# iudanet_infra

![github actions linter](https://github.com/Otus-DevOps-2020-11/iudanet_infra/workflows/linter/badge.svg)

## iudanet Infra repository

## HW-10

### Сделано

* создана роль app
* создана роль db
* создан плейбук для создания пользователей
  * параметры пользователей заданы через зашифрованные переменные в ansible vault
* новая структура каталогов в ansible
* создано окружение для stage и prod
* dynamic inventory перенесен в окружения
  * TODO: Доработать скрипт dynamic inventory, для работы с несколькими окружениями, наверно нужен лейбл из переменных Terraform с именем окружения и при запуске скрипта искать переменную env в group_vars ansible, по ней будет происходить фильтрация хостов для инвентори.
* добавлены линтеры в github actions для задания **
  * из-за недоступности секретов на github, не сделал ansible-lint. Ругается на шифрованные переменные.

* Добавлен бейдж статуса линтера

  ![github actions linter](https://github.com/Otus-DevOps-2020-11/iudanet_infra/workflows/linter/badge.svg)

### Тесты

```txt
  ✔  ansible: Run ansible validation
     ✔  Command: `cd ansible && ansible-galaxy install -r environments/stage/requirements.yml` exit_status should eq 0
     ✔  Command: `cd ansible && ansible-lint playbooks/site.yml --exclude=roles/jdauphant.nginx` stdout should eq ""
     ✔  Command: `cd ansible && ansible-lint playbooks/site.yml --exclude=roles/jdauphant.nginx` exit_status should eq 0
     ✔  Command: `find ansible/playbooks -name "*.yml" -type f -print0 | ANSIBLE_ROLES_PATH=ansible/roles xargs -0 -n1 ansible-playbook --syntax-check` stderr should not match /The error appears to have been/
     ✔  Command: `find ansible/playbooks -name "*.yml" -type f -print0 | ANSIBLE_ROLES_PATH=ansible/roles xargs -0 -n1 ansible-playbook --syntax-check` exit_status should eq 0
  ✔  structure: Check repo structure
     ✔  Directory ansible should exist
     ✔  Directory ansible/playbooks should exist
     ✔  Directory ansible/roles should exist
     ✔  Directory ansible/old should exist
     ✔  Directory ansible/roles/app should exist
     ✔  Directory ansible/roles/db should exist
     ✔  Directory ansible/environments should exist
     ✔  Directory ansible/environments should exist
     ✔  Directory ansible/environments/stage should exist
     ✔  Directory ansible/environments/stage/group_vars should exist
     ✔  Directory ansible/environments/prod should exist
     ✔  Directory ansible/environments/prod/group_vars should exist
     ✔  File .gitignore should exist
     ✔  File .gitignore content should match /\n\Z/
     ✔  File README.md should exist
     ✔  File README.md content should match /\n\Z/
     ✔  File ansible/requirements.txt should exist
     ✔  File ansible/requirements.txt content should match /\n\Z/
     ✔  File ansible/ansible.cfg should exist
     ✔  File ansible/ansible.cfg content should match /\n\Z/
     ✔  File ansible/playbooks/packer_app.yml should exist
     ✔  File ansible/playbooks/packer_app.yml content should match /\n\Z/
     ✔  File ansible/playbooks/packer_db.yml should exist
     ✔  File ansible/playbooks/packer_db.yml content should match /\n\Z/
     ✔  File ansible/playbooks/site.yml should exist
     ✔  File ansible/playbooks/site.yml content should match /\n\Z/
     ✔  File ansible/playbooks/users.yml should exist
     ✔  File ansible/playbooks/users.yml content should match /\n\Z/
     ✔  File ansible/playbooks/app.yml should exist
     ✔  File ansible/playbooks/app.yml content should match /\n\Z/
     ✔  File ansible/playbooks/db.yml should exist
     ✔  File ansible/playbooks/db.yml content should match /\n\Z/
     ✔  File ansible/playbooks/deploy.yml should exist
     ✔  File ansible/playbooks/deploy.yml content should match /\n\Z/
     ✔  File ansible/environments/stage/requirements.yml should exist
     ✔  File ansible/environments/stage/requirements.yml content should match /\n\Z/
     ✔  File ansible/environments/prod/requirements.yml should exist
     ✔  File ansible/environments/prod/requirements.yml content should match /\n\Z/
     ✔  File .gitignore content should match /jdauphant.nginx/
  ✔  packer: Run packer validate
     ✔  File packer/app.json should exist
     ✔  File packer/app.json content should match /\n\Z/
     ✔  File packer/db.json should exist
     ✔  File packer/db.json content should match /\n\Z/
     ✔  File packer/variables.json.example should exist
     ✔  File packer/variables.json.example content should match /\n\Z/
     ✔  File ansible/playbooks/packer_app.yml should exist
     ✔  File ansible/playbooks/packer_app.yml content should match /\n\Z/
     ✔  File ansible/playbooks/packer_db.yml should exist
     ✔  File ansible/playbooks/packer_db.yml content should match /\n\Z/
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` stdout should eq "Template validated successfully.\n"
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` stderr should eq ""
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` exit_status should eq 0
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` stdout should eq "Template validated successfully.\n"
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` stderr should eq ""
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` exit_status should eq 0


Profile Summary: 3 successful controls, 0 control failures, 0 controls skipped
Test Summary: 60 successful, 0 failures, 0 skipped
```

## HW-9

* Созданы ansible плейбуки для деплой db  и app
* модифицирован динамический инвентори. Переменные берутся из лейблов виртуальных машин.
* сборка packer модифицированная под ansible

```txt
packer build -var-file=packer/variables.json packer/db.json
packer build -var-file=packer/variables.json packer/app.json

```

* Для прохождения тестов добавлено
  * ansible.cfg в корень со статическим инвентори
  * конфиг packer тестируется от корня, пришлось добавить путь к ключу относительно корня в variables.json.example

```txt
  ✔  ansible: Run ansible validation
     ✔  Command: `find ansible ! -name "inventory*.yml" -name "*.yml" -type f -print0 | xargs -0 -n1 ansible-playbook --syntax-check` stderr should not match /The error appears to have been/
     ✔  Command: `find ansible ! -name "inventory*.yml" -name "*.yml" -type f -print0 | xargs -0 -n1 ansible-playbook --syntax-check` exit_status should eq 0
  ✔  structure: Check repo structure
     ✔  Directory ansible should exist
     ✔  Directory ansible/files should exist
     ✔  Directory ansible/templates should exist
     ✔  File .gitignore should exist
     ✔  File .gitignore content should match /\n\Z/
     ✔  File README.md should exist
     ✔  File README.md content should match /\n\Z/
     ✔  File ansible/requirements.txt should exist
     ✔  File ansible/requirements.txt content should match /\n\Z/
     ✔  File ansible/ansible.cfg should exist
     ✔  File ansible/ansible.cfg content should match /\n\Z/
     ✔  File ansible/inventory should exist
     ✔  File ansible/inventory content should match /\n\Z/
     ✔  File ansible/inventory.yml should exist
     ✔  File ansible/inventory.yml content should match /\n\Z/
     ✔  File ansible/clone.yml should exist
     ✔  File ansible/clone.yml content should match /\n\Z/
     ✔  File ansible/packer_app.yml should exist
     ✔  File ansible/packer_app.yml content should match /\n\Z/
     ✔  File ansible/packer_db.yml should exist
     ✔  File ansible/packer_db.yml content should match /\n\Z/
     ✔  File ansible/reddit_app_multiple_plays.yml should exist
     ✔  File ansible/reddit_app_multiple_plays.yml content should match /\n\Z/
     ✔  File ansible/reddit_app_one_play.yml should exist
     ✔  File ansible/reddit_app_one_play.yml content should match /\n\Z/
     ✔  File ansible/site.yml should exist
     ✔  File ansible/site.yml content should match /\n\Z/
     ✔  File ansible/app.yml should exist
     ✔  File ansible/app.yml content should match /\n\Z/
     ✔  File ansible/db.yml should exist
     ✔  File ansible/db.yml content should match /\n\Z/
     ✔  File ansible/deploy.yml should exist
     ✔  File ansible/deploy.yml content should match /\n\Z/
  ✔  packer: Run packer validate
     ✔  File packer/app.json should exist
     ✔  File packer/app.json content should match /\n\Z/
     ✔  File packer/db.json should exist
     ✔  File packer/db.json content should match /\n\Z/
     ✔  File packer/variables.json.example should exist
     ✔  File packer/variables.json.example content should match /\n\Z/
     ✔  File ansible/packer_app.yml should exist
     ✔  File ansible/packer_app.yml content should match /\n\Z/
     ✔  File ansible/packer_db.yml should exist
     ✔  File ansible/packer_db.yml content should match /\n\Z/
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` stdout should eq "Template validated successfully.\n"
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` stderr should eq ""
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` exit_status should eq 0
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` stdout should eq "Template validated successfully.\n"
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` stderr should eq ""
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` exit_status should eq 0


Profile Summary: 3 successful controls, 0 control failures, 0 controls skipped
Test Summary: 51 successful, 0 failures, 0 skipped
```

## HW-8

* После выполнения команды удаления папки, запуск плейбука будет в статусе `change` так как Ansible создал папку и склонировал в нее репозиторий.

```txt
Теперь выполните ansible app -m command -a 'rm -rf~/reddit'  и  проверьте  еще  раз  выполнение  плейбука.
Чтоизменилось и почему? Добавьте информацию в README.md.
```

* Написан скрипт Dynamic Inventory

## HW-8

* После выполнения команды удаления папки, запуск плейбука будет в статусе `change` так как Ansible создал папку и склонировал в нее репозиторий.

```txt
Теперь выполните ansible app -m command -a 'rm -rf~/reddit'  и  проверьте  еще  раз  выполнение  плейбука.
Чтоизменилось и почему? Добавьте информацию в README.md.
```

## HW-9

* Созданы ansible плейбуки для деплой db  и app
* модифицирован динамический инвентори. Переменные берутся из лейблов виртуальных машин.
* сборка packer модифицированная под ansible

```txt
packer build -var-file=packer/variables.json packer/db.json
packer build -var-file=packer/variables.json packer/app.json

```

* Для прохождения тестов добавлено
  * ansible.cfg в корень со статическим инвентори
  * конфиг packer тестируется от корня, пришлось добавить путь к ключу относительно корня в variables.json.example

```txt
  ✔  ansible: Run ansible validation
     ✔  Command: `find ansible ! -name "inventory*.yml" -name "*.yml" -type f -print0 | xargs -0 -n1 ansible-playbook --syntax-check` stderr should not match /The error appears to have been/
     ✔  Command: `find ansible ! -name "inventory*.yml" -name "*.yml" -type f -print0 | xargs -0 -n1 ansible-playbook --syntax-check` exit_status should eq 0
  ✔  structure: Check repo structure
     ✔  Directory ansible should exist
     ✔  Directory ansible/files should exist
     ✔  Directory ansible/templates should exist
     ✔  File .gitignore should exist
     ✔  File .gitignore content should match /\n\Z/
     ✔  File README.md should exist
     ✔  File README.md content should match /\n\Z/
     ✔  File ansible/requirements.txt should exist
     ✔  File ansible/requirements.txt content should match /\n\Z/
     ✔  File ansible/ansible.cfg should exist
     ✔  File ansible/ansible.cfg content should match /\n\Z/
     ✔  File ansible/inventory should exist
     ✔  File ansible/inventory content should match /\n\Z/
     ✔  File ansible/inventory.yml should exist
     ✔  File ansible/inventory.yml content should match /\n\Z/
     ✔  File ansible/clone.yml should exist
     ✔  File ansible/clone.yml content should match /\n\Z/
     ✔  File ansible/packer_app.yml should exist
     ✔  File ansible/packer_app.yml content should match /\n\Z/
     ✔  File ansible/packer_db.yml should exist
     ✔  File ansible/packer_db.yml content should match /\n\Z/
     ✔  File ansible/reddit_app_multiple_plays.yml should exist
     ✔  File ansible/reddit_app_multiple_plays.yml content should match /\n\Z/
     ✔  File ansible/reddit_app_one_play.yml should exist
     ✔  File ansible/reddit_app_one_play.yml content should match /\n\Z/
     ✔  File ansible/site.yml should exist
     ✔  File ansible/site.yml content should match /\n\Z/
     ✔  File ansible/app.yml should exist
     ✔  File ansible/app.yml content should match /\n\Z/
     ✔  File ansible/db.yml should exist
     ✔  File ansible/db.yml content should match /\n\Z/
     ✔  File ansible/deploy.yml should exist
     ✔  File ansible/deploy.yml content should match /\n\Z/
  ✔  packer: Run packer validate
     ✔  File packer/app.json should exist
     ✔  File packer/app.json content should match /\n\Z/
     ✔  File packer/db.json should exist
     ✔  File packer/db.json content should match /\n\Z/
     ✔  File packer/variables.json.example should exist
     ✔  File packer/variables.json.example content should match /\n\Z/
     ✔  File ansible/packer_app.yml should exist
     ✔  File ansible/packer_app.yml content should match /\n\Z/
     ✔  File ansible/packer_db.yml should exist
     ✔  File ansible/packer_db.yml content should match /\n\Z/
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` stdout should eq "Template validated successfully.\n"
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` stderr should eq ""
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/app.json` exit_status should eq 0
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` stdout should eq "Template validated successfully.\n"
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` stderr should eq ""
     ✔  Command: `packer validate -var-file=packer/variables.json.example packer/db.json` exit_status should eq 0


Profile Summary: 3 successful controls, 0 control failures, 0 controls skipped
Test Summary: 51 successful, 0 failures, 0 skipped
```


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
