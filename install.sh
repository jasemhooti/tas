#!/bin/bash

set -e

echo "🔄 در حال نصب پیش‌نیازها ..."

# بروزرسانی مخازن و نصب پایتون و ابزارهای ضروری
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv curl unzip git

# ایجاد دایرکتوری و دانلود سورس‌کد ربات
cd /root
rm -rf tas
git clone https://github.com/jasemhooti/tas.git
cd tas

# دریافت اطلاعات مورد نیاز
read -p "📌 لطفاً توکن ربات را وارد کنید: " BOT_TOKEN
read -p "📌 لطفاً آیدی عددی ادمین را وارد کنید: " ADMIN_ID

# ذخیره اطلاعات در فایل .env
echo "BOT_TOKEN=$BOT_TOKEN" > .env
echo "ADMIN_ID=$ADMIN_ID" >> .env

# ایجاد محیط مجازی برای نصب پکیج‌ها
echo "📦 در حال ساخت محیط مجازی..."
python3 -m venv venv

# فعال‌سازی محیط مجازی
source venv/bin/activate

# نصب وابستگی‌های پایتون
echo "🔧 در حال نصب وابستگی‌ها ..."
pip install --upgrade pip
pip install -r requirements.txt

# ساخت فایل سرویس systemd
cat <<EOF | sudo tee /etc/systemd/system/tasbot.service
[Unit]
Description=Telegram Dice Bot
After=network.target

[Service]
ExecStart=/root/tas/venv/bin/python /root/tas/bot.py
WorkingDirectory=/root/tas
Environment="BOT_TOKEN=$BOT_TOKEN"
Environment="ADMIN_ID=$ADMIN_ID"
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# بارگذاری سرویس و اجرای آن
echo "🔄 در حال بارگذاری سرویس ..."
sudo systemctl daemon-reload
sudo systemctl enable tasbot
sudo systemctl restart tasbot

echo "✅ نصب کامل شد! ربات اجرا شد."
