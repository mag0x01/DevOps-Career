# Example 1

Using the files in the example you can test the ansible-inventory and ansible ad hoc commands

```console
ansible-inventory -i inventory --graph
ansible-inventory -i inventory --list -y

ansible -i inventory -m ping all

```