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

Чтобы создать Telegram-бота для приёма оповещений (alerts) из Grafana, нужно выполнить следующие шаги:

1. Создание Telegram-бота и получение API токена:
- Откройте Telegram и найдите бота с именем BotFather.
- Отправьте ему команду /newbot.
- Следуйте инструкциям для выбора имени и username бота (должен заканчиваться на "bot" или "_bot").
- После создания бота BotFather предоставит вам API токен — сохраните его.

2. Получение Chat ID:
- Создайте в Telegram группу или используйте уже существующую.
- Добавьте в эту группу своего бота.
- Чтобы узнать Chat ID группы, откройте Telegram через браузер (https://web.telegram.org), зайдите в нужный чат, и в адресной строке будет ID после символа #, например, -123456789.
- Либо через API вызов https://api.telegram.org/bot/getUpdates можно получить ID чата.

3. Настройка Grafana для отправки оповещений в Telegram:
- Зайдите в Grafana, в меню выберите Alerting -> Contact points.
- Нажмите "+ Add contact point".
- Введите имя (например, telegram_alerts).
- В списке Integration выберите Telegram.
- В поля BOT API Token и Chat ID вставьте соответствующие значения.
- Нажмите Test для проверки работоспособности.
- Сохраните контактную точку.

4. Подключение Telegram-уведомлений к правилам оповещений:
- Перейдите в Alerting -> Alert rules.
- Отредактируйте существующее или создайте новое правило оповещения.
- В разделе Configure labels and notifications выберите ранее созданный контакт point Telegram.
- Сохраните правило.

После этого при срабатывании правил оповещения вы будете получать сообщения от бота в Telegram. 

Обратите внимание, что Telegram ограничивает длину сообщений 4096 UTF-8 символов, учитывайте это при формировании текстов оповещений.

Эти шаги обеспечивают стандартную интеграцию между Grafana и Telegram для получения alert-уведомлений.[1][2][3][4]