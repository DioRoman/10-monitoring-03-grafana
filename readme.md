cd /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/terraform

terraform apply -auto-approve

cd ansible

ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-prometheus.yml

ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-grafana.yml

ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-node-exporter.yml

ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/connected-node-exporter.yml

Создайте Dashboard и в ней создайте Panels:

утилизация CPU для nodeexporter (в процентах, 100-idle);

100 * (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) by (instance))

CPULA 1/5/15;

node_load1 node_load5 node_load15

количество свободной оперативной памяти;

node_memory_MemAvailable_bytes / 1024 / 1024

количество места на файловой системе.

node_filesystem_free_bytes{mountpoint="/", fstype!~"tmpfs|overlay"} / 1024 / 1024 / 1024
