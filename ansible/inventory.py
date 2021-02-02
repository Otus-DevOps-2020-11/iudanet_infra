#!/usr/bin/env python3
import os
import sys
import json as j
import subprocess
import click

def get_yc_json() -> str:
    """
    Запускает установленный и настроенный yc кли
    интерфейс для яндекс облока, получает на выходе json.
    """
    command_get_nodes = ['yc', 'compute', 'instance', 'list', '--format', 'json']
    result = subprocess.run(command_get_nodes, stdout=subprocess.PIPE)
    return j.loads(result.stdout)


def get_group_list(json) -> list:
    """
    Получает на вход json от yc
    Возвращает list со списком групп из json yc
    Имя группы берется из тега ansible_group
    """
    group_list = []
    for host_data in json:
        name = host_data['labels']['ansible_group']
        group_list.append(name)
    return group_list

def get_name_list(json) -> list:
    """
    Получает на вход json от yc
    Возвращает list со списком всех имен хостов из json yc
    Имя группы берется из тега ansible_name
    """
    name_list = []
    for host_data in json:
        name = host_data['labels']['ansible_name']
        name_list.append(name)
    return name_list

def get_ip_host(name, json) -> str:
    """
    Получает на вход json от yc и имя хоста
    Возвращает  NAT IP адрес с 1 интерфейса хоста
    """
    for host_data in json:
        host_name =  host_data['labels']['ansible_name']
        host_ip = host_data['network_interfaces'][0]['primary_v4_address']['one_to_one_nat']['address']
        if host_name == name:
            return host_ip
    return "127.0.0.1"

def get_list_host_to_group(group, json) -> list:
    """
    Получает на вход json от yc и имя группы
    Возвращает  list со списком хостов в группе
    """
    host_list = []
    for host_data in json:
        host_group = host_data['labels']['ansible_group']
        host_name = host_data['labels']['ansible_name']
        if host_group == group:
            host_list.append(host_name)
    return host_list

def get_inventory_json(json) -> str:
    """
    Получает на вход json от yc
    Возвращает  json c inventry для ansible
    """
    inventory = {}
    # добавляем группу all
    inventory['all'] = {}
    inventory['all']['children'] = []
    inventory['all']['children'].extend(["ungrouped"])
    inventory['all']['children'].extend(get_group_list(json))
    # Добавляем _meta
    inventory['_meta'] = {}
    inventory['_meta']['hostvars'] = {}
    for host in get_name_list(json=json):
        inventory['_meta']['hostvars'][host] = {}
        inventory['_meta']['hostvars'][host]['ansible_host'] = get_ip_host(name=host, json=json)
    for group in get_group_list(json):
        inventory[group] = {}
        inventory[group]['hosts'] = get_list_host_to_group( group=group, json=json)
    return inventory

@click.command()
@click.option('--list', is_flag=True, help="print inventory")
def main(list) -> str:
    # create_parser.set_defaults(func=main )
    json = get_yc_json()
    inventory = get_inventory_json(json=json)
    print(j.dumps(inventory, sort_keys=True, indent=4))
    sys.exit(0)

if __name__== "__main__":
    main()
