#!/bin/bash

echo "🚀 نصب ربات تلگرام تاس دو نفره در حال اجراست..."

# گرفتن اطلاعات از کاربر
read -p "🛠 لطفاً توکن ربات را وارد کنید: " BOT_TOKEN
read -p "👑 لطفاً آیدی عددی ادمین را وارد کنید: " ADMIN_ID

# بروزرسانی و نصب پیش‌نیازها
echo "🔄 در حال بروزرسانی سیستم و نصب پیش‌نیازها..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip

# نصب کتابخانه‌های مورد نیاز
echo "📦 در حال نصب کتابخانه‌های پایتون..."
pip3 install python-telegram-bot --upgrade

# کلون کردن یا بروزرسانی سورس کد از گیت‌هاب
if [ -d "telegram-dice-bot" ]; then
    echo "🔄 بروزرسانی سورس کد..."
    cd telegram-dice-bot && git pull
else
    echo "📥 دریافت سورس کد از گیت‌هاب..."
    git clone https://github.com/jasemhooti/telegram-dice-bot.git
    cd telegram-dice-bot
fi

# ایجاد فایل .env برای ذخیره اطلاعات حساس
echo "🔐 ذخیره توکن و آیدی ادمین..."
echo "BOT_TOKEN=$BOT_TOKEN" > .env
echo "ADMIN_ID=$ADMIN_ID" >> .env

# اجرای ربات
echo "🚀 اجرای ربات..."
nohup python3 bot.py &

echo "✅ ربات با موفقیت نصب و اجرا شد!"
echo "برای دیدن لاگ‌های ربات از دستور زیر استفاده کنید:"
echo "tail -f nohup.out"
