#!/bin/bash

# بررسی اینکه آیا Python3 و pip3 نصب شده باشد
echo "بررسی نصب Python3 و pip3 ..."
sudo apt update
sudo apt install -y python3 python3-pip python3-venv

# ایجاد محیط مجازی (virtualenv)
echo "ایجاد محیط مجازی Python..."
python3 -m venv /root/tas/venv

# فعال‌سازی محیط مجازی
echo "فعال‌سازی محیط مجازی..."
source /root/tas/venv/bin/activate

# نصب پکیج‌های مورد نیاز
echo "نصب پکیج‌های مورد نیاز..."
pip install python-telegram-bot

# اطلاع‌رسانی از نصب کامل
echo "پکیج‌ها نصب شدند!"

# نصب سرویس systemd
echo "راه‌اندازی سرویس systemd برای ربات..."
cat <<EOL > /etc/systemd/system/tasbot.service
[Unit]
Description=Telegram Dice Bot
After=network.target

[Service]
ExecStart=/root/tas/venv/bin/python /root/tas/bot.py
WorkingDirectory=/root/tas
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# فعال‌سازی و راه‌اندازی سرویس
echo "فعال‌سازی و شروع سرویس..."
sudo systemctl daemon-reload
sudo systemctl enable tasbot
sudo systemctl start tasbot

echo "نصب و راه‌اندازی ربات با موفقیت انجام شد!"
