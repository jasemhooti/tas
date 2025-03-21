from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Updater, CommandHandler, CallbackQueryHandler, CallbackContext
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
    # ایجاد دکمه‌های شفاف (شیشه‌ای)
    keyboard = [
        [InlineKeyboardButton("🎲 انداختن تاس", callback_data='roll_dice')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    update.message.reply_text('سلام! ربات بازی تاس آماده است. برای انداختن تاس روی دکمه زیر کلیک کنید.', reply_markup=reply_markup)

# تابع بازی تاس
def roll_dice(update: Update, context: CallbackContext) -> None:
    query = update.callback_query
    query.answer()

    dice_roll = random.randint(1, 6)  # انداختن تاس
    query.edit_message_text(f"عدد تاس: {dice_roll}")

# تابع مدیریت کلیک روی دکمه‌ها
def button_handler(update: Update, context: CallbackContext) -> None:
    query = update.callback_query
    if query.data == 'roll_dice':
        roll_dice(update, context)

def main() -> None:
    # استفاده از Updater و انتقال توکن ربات
    updater = Updater(TELEGRAM_TOKEN)

    # دریافت دیسپیچر برای اضافه کردن هندلرها
    dispatcher = updater.dispatcher

    # افزودن دستور start
    dispatcher.add_handler(CommandHandler("start", start))

    # افزودن هندلر برای مدیریت کلیک روی دکمه‌ها
    dispatcher.add_handler(CallbackQueryHandler(button_handler))

    # شروع دریافت پیام‌ها
    updater.start_polling()

    # اجرا برای همیشه
    updater.idle()

if __name__ == '__main__':
    main()
