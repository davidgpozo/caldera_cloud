# install-ansible

An Ansible role for installing and configuring MITRE Caldera

## OS Platforms

This role has been tested on the following operating systems:

- Ubuntu 22.04

## Usage

To use this role in your playbook, add the code below:

```
- role: ansible-caldera
    vars:
      dir: '{{ node_app_dir }}/install-caldera/'
```