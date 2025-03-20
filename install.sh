#!/bin/bash

# نصب پیش‌نیازهای سیستم
echo "در حال نصب پیش‌نیازها..."
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git

# ساخت دایرکتوری پروژه
echo "در حال ایجاد دایرکتوری برای پروژه..."
mkdir -p /root/tas
cd /root/tas

# کلون کردن پروژه از گیت‌هاب
echo "در حال کلون کردن پروژه از گیت‌هاب..."
git clone https://github.com/jasemhooti/tas.git .

# ساخت محیط مجازی
echo "در حال ساخت محیط مجازی..."
python3 -m venv venv

# فعال کردن محیط مجازی
source venv/bin/activate

# نصب پکیج‌های مورد نیاز
echo "در حال نصب پکیج‌های مورد نیاز..."
pip install --upgrade pip
pip install python-telegram-bot

# ایجاد فایل سرویس systemd
echo "در حال ایجاد فایل سرویس systemd..."
sudo bash -c 'cat > /etc/systemd/system/tasbot.service <<EOL
[Unit]
Description=Telegram Dice Bot
After=network.target

[Service]
User=root
WorkingDirectory=/root/tas
ExecStart=/root/tas/venv/bin/python /root/tas/bot.py
Restart=always

[Install]
WantedBy=multi-user.target
EOL'

# فعال کردن و راه‌اندازی سرویس
echo "در حال فعال کردن سرویس..."
sudo systemctl daemon-reload
sudo systemctl enable tasbot
sudo systemctl start tasbot

# پیام موفقیت
echo "نصب و راه‌اندازی ربات با موفقیت انجام شد!"
