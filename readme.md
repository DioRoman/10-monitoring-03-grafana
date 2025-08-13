cd /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/terraform

cd ansible

ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-prometheus.yml

ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-grafana.yml

ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-node-exporter.yml