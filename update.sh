#!/bin/bash

# نمایش پیام شروع
echo "🔄 در حال بروزرسانی ربات از GitHub..."

# تغییر مسیر به دایرکتوری پروژه
cd /root/tas || { echo "❌ خطا: دایرکتوری پروژه یافت نشد!"; exit 1; }

# دریافت آخرین تغییرات از GitHub
git pull origin main || { echo "❌ خطا: دریافت تغییرات از GitHub ناموفق بود!"; exit 1; }

# فعال‌سازی محیط مجازی و نصب پیش‌نیازها
source venv/bin/activate
pip install -r requirements.txt
deactivate

# ری‌استارت کردن سرویس ربات
echo "🔄 ری‌استارت کردن ربات..."
sudo systemctl restart tasbot || { echo "❌ خطا: ربات ری‌استارت نشد!"; exit 1; }

# بررسی وضعیت ربات
sudo systemctl status tasbot --no-pager

echo "✅ بروزرسانی ربات با موفقیت انجام شد!"
