# 📘 Обобщённая документация по Terraform и Ansible для инфраструктуры мониторинга  

## Общий смысл  
Данный проект автоматизирует развёртывание и настройку **стека мониторинга (Prometheus + Node Exporter + Grafana)** в **Yandex Cloud**.  
Terraform создаёт облачную инфраструктуру (сеть, виртуальные машины и правила безопасности), а Ansible конфигурирует установленные сервисы и настраивает их взаимную интеграцию.  

В итоге получается связка:  
- **Node Exporter** собирает метрики с серверов,  
- **Prometheus** агрегирует и хранит данные,  
- **Grafana** предоставляет визуализацию и дашборды.  

***

## Основные шаги

### 1. Terraform (инфраструктура)
- Разворачивает VPC, подсети и security group с доступом на нужные порты (22, 80, 443, 9090, 9100, 3000).  
- Создаёт три ВМ:  
  - **Prometheus VM** – сбор и хранение метрик (порт 9090);  
  - **Node Exporter VM** – агент мониторинга ОС (порт 9100);  
  - **Grafana VM** – визуализация метрик (порт 3000).  
- Применяет cloud-init для настройки пользователей и ключей.  

### 2. Ansible (конфигурация сервисов)
- **Prometheus**: установка бинарников, настройка директорий, добавление systemd‑сервиса.  
- **Grafana**: установка пакета, конфигурация пользователя и папок, запуск systemd‑сервиса.  
- **Node Exporter**: установка бинарника, настройка systemd‑сервиса.  
- **Интеграция**: обновление `prometheus.yml`, добавление таргетов Node Exporter и перезапуск Prometheus.  

***

## Результат
После `terraform apply` и запуска ansible‑playbook:  
- В облаке разворачивается инфраструктура с ВМ под Prometheus, Grafana и Node Exporter.  
- Все сервисы установлены и запущены как systemd‑службы.  
- Prometheus автоматически собирает метрики с Node Exporter, а Grafana готова для создания дашбордов.  
- Итоговая система — **готовый к работе стек мониторинга инфраструктуры**.  

***

<details>
  <summary>Полезные команды</summary>


`cd /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/terraform`

`terraform apply -auto-approve`

`ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-prometheus.yml`

`ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-grafana.yml`

`ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/install-node-exporter.yml`

`ansible-playbook -i /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/inventories/hosts.yml /mnt/c/Users/rlyst/Netology/10-monitoring-03-grafana/ansible/connected-node-exporter.yml`

утилизация CPU для nodeexporter (в процентах, 100-idle);

`100 * (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) by (instance))`

CPULA 1/5/15;

`node_load1` 

`node_load5` 

`node_load15`

количество свободной оперативной памяти;

`node_memory_MemAvailable_bytes / 1024 / 1024`

количество места на файловой системе.

`node_filesystem_free_bytes{mountpoint="/", fstype!~"tmpfs|overlay"} / 1024 / 1024 / 1024`

</details>

# 📘 Интеграция Grafana с Telegram для оповещений

## 🚀 Общий смысл
Интеграция позволяет получать оповещения (**alerts**) из Grafana напрямую в Telegram‑чат или группу через специально созданного бота.  

---

## 🔹 1. Создание Telegram-бота и получение API токена
1. В Telegram найдите бота **BotFather**.  
2. Отправьте ему команду:  

/newbot

```markdown
# 📘 Интеграция Grafana с Telegram для оповещений

## 🚀 Общий смысл
Интеграция позволяет получать оповещения (**alerts**) из Grafana напрямую в Telegram‑чат или группу через специально созданного бота.  

---

## 🔹 1. Создание Telegram-бота и получение API токена
1. В Telegram найдите бота **BotFather**.  
2. Отправьте ему команду:  
   ```
   /newbot
   ```
3. Следуйте инструкциям: выберите имя и `username` (имя должно заканчиваться на `bot` или `_bot`).  
4. После создания BotFather вернёт **API токен** — сохраните его, он понадобится для настройки Grafana.  

---

## 🔹 2. Получение Chat ID
1. Создайте в Telegram группу или используйте существующую.  
2. Добавьте в неё вашего нового бота.  
3. Узнать Chat ID можно двумя способами:  
   - Через **web.telegram.org**: откройте группу, в адресной строке будет ID чата после символа `#` (например: `-123456789`).  
   - Через API:  
     ```
     https://api.telegram.org/bot/getUpdates
     ```
     В ответе найдите поле `chat -> id`.  

---

## 🔹 3. Настройка Grafana для отправки оповещений в Telegram
1. В Grafana откройте меню: **Alerting → Contact points**.  
2. Нажмите **+ Add contact point**.  
3. Укажите имя (например, `telegram_alerts`).  
4. В списке **Integration** выберите `Telegram`.  
5. Введите:  
   - **Bot API Token** — полученный от BotFather токен.  
   - **Chat ID** — ID группы/чата.  
6. Нажмите **Test** для проверки работы.  
7. Сохраните контактную точку.  

---

## 🔹 4. Подключение Telegram-уведомлений к правилам оповещений
1. Перейдите в Grafana: **Alerting → Alert rules**.  
2. Создайте новое правило или отредактируйте существующее.  
3. В разделе **Configure labels and notifications** выберите созданный контакт (`telegram_alerts`).  
4. Сохраните правило.  

---

## ✅ Результат
Теперь при срабатывании правил оповещений Grafana будет отправлять сообщения в ваш Telegram‑чат через созданного бота.  

После этого при срабатывании правил оповещения вы будете получать сообщения от бота в Telegram. 

Обратите внимание, что Telegram ограничивает длину сообщений 4096 UTF-8 символов, учитывайте это при формировании текстов оповещений.

Эти шаги обеспечивают стандартную интеграцию между Grafana и Telegram для получения alert-уведомлений.