#!/bin/bash

echo "🚀 نصب ربات تلگرام تاس دو نفره در حال اجراست..."

# گرفتن اطلاعات از کاربر
read -p "🛠 لطفاً توکن ربات را وارد کنید: " BOT_TOKEN
read -p "👑 لطفاً آیدی عددی ادمین را وارد کنید: " ADMIN_ID

# بروزرسانی و نصب پیش‌نیازها
echo "🔄 در حال بروزرسانی سیستم و نصب پیش‌نیازها..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip git

# نصب کتابخانه‌های مورد نیاز
echo "📦 در حال نصب کتابخانه‌های پایتون..."
pip3 install python-telegram-bot --upgrade

# دریافت سورس کد از گیت‌هاب
if [ -d "tas" ]; then
    echo "🔄 بروزرسانی سورس کد..."
    cd tas && git pull
else
    echo "📥 دریافت سورس کد از گیت‌هاب..."
    git clone https://github.com/jasemhooti/tas.git
    cd tas
fi

# ذخیره توکن و آیدی ادمین
echo "🔐 ذخیره توکن و آیدی ادمین..."
echo "BOT_TOKEN=$BOT_TOKEN" > .env
echo "ADMIN_ID=$ADMIN_ID" >> .env

# اجرای ربات به صورت دائمی با `systemd`
echo "🚀 تنظیم ربات برای اجرا به‌صورت دائمی..."
cat <<EOF | sudo tee /etc/systemd/system/tasbot.service
[Unit]
Description=Telegram Dice Bot
After=network.target

[Service]
ExecStart=/usr/bin/python3 $(pwd)/bot.py
WorkingDirectory=$(pwd)
Environment="BOT_TOKEN=$BOT_TOKEN"
Environment="ADMIN_ID=$ADMIN_ID"
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# فعال‌سازی و اجرای سرویس
sudo systemctl daemon-reload
sudo systemctl enable tasbot
sudo systemctl restart tasbot

echo "✅ ربات با موفقیت نصب و اجرا شد!"
echo "برای بررسی وضعیت ربات از این دستور استفاده کنید:"
echo "sudo systemctl status tasbot"
