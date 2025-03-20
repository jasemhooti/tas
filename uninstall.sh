#!/bin/bash

set -e

echo "🔴 در حال حذف ربات از سرور ..."

# توقف سرویس tasbot
echo "🔴 توقف سرویس tasbot ..."
sudo systemctl stop tasbot

# غیرفعال کردن سرویس tasbot از auto-start
echo "🔴 غیرفعال کردن سرویس tasbot ..."
sudo systemctl disable tasbot

# حذف فایل سرویس systemd
echo "🔴 حذف فایل سرویس tasbot ..."
sudo rm -f /etc/systemd/system/tasbot.service

# بارگذاری مجدد سرویس‌های systemd
echo "🔴 بارگذاری مجدد سرویس‌های systemd ..."
sudo systemctl daemon-reload

# حذف دایرکتوری پروژه tas
echo "🔴 حذف دایرکتوری پروژه tas ..."
sudo rm -rf /root/tas

# حذف محیط مجازی (در صورت وجود)
echo "🔴 حذف محیط مجازی ..."
sudo rm -rf /root/tas/venv

echo "✅ حذف ربات از سرور با موفقیت انجام شد!"
