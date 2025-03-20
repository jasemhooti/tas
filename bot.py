from telegram import Update
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters, CallbackContext
import logging
import random

# فعال کردن لاگینگ برای بررسی اشکالات
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)
logger = logging.getLogger(__name__)

# توکن ربات تلگرام
TELEGRAM_TOKEN = "6414210268:AAEL-RZiABoMzS_QY922hOQnpXcam9OgiF0"

# تابع start برای شروع ربات
def start(update: Update, context: CallbackContext) -> None:
    update.message.reply_text('سلام! ربات بازی تاس آماده است. برای انداختن تاس دستور /roll را وارد کنید.')

# تابع بازی تاس
def roll_dice(update: Update, context: CallbackContext) -> None:
    dice_roll = random.randint(1, 6)  # انداختن تاس
    update.message.reply_text(f"عدد تاس: {dice_roll}")

def main() -> None:
    # استفاده از Updater و انتقال توکن ربات
    updater = Updater(TELEGRAM_TOKEN)

    # دریافت دیسپیچر برای اضافه کردن هندلرها
    dispatcher = updater.dispatcher

    # افزودن دستور start
    dispatcher.add_handler(CommandHandler("start", start))

    # افزودن دستور roll_dice
    dispatcher.add_handler(CommandHandler("roll", roll_dice))

    # شروع دریافت پیام‌ها
    updater.start_polling()

    # اجرا برای همیشه
    updater.idle()

if __name__ == '__main__':
    main()
