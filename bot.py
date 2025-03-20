import logging
from telegram import Update
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters, CallbackContext
import random

# تنظیمات لوگ
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)
logger = logging.getLogger(__name__)

# توکن ربات تلگرام شما
TOKEN = "6414210268:AAEL-RZiABoMzS_QY922hOQnpXcam9OgiF0"

# فرمان شروع
def start(update: Update, context: CallbackContext) -> None:
    update.message.reply_text('سلام! من ربات تاس اندازی هستم. برای شروع بازی بگو /play')

# فرمان بازی
def play(update: Update, context: CallbackContext) -> None:
    user_choice = context.args[0] if context.args else None
    if not user_choice or not user_choice.isdigit() or int(user_choice) not in [1, 2, 3, 4, 5, 6]:
        update.message.reply_text("لطفاً یک عدد از 1 تا 6 را انتخاب کن.")
        return
    
    # تاس انداختن
    dice_roll = random.randint(1, 6)
    if int(user_choice) == dice_roll:
        update.message.reply_text(f"تبریک! شما درست حدس زدید. تاس افتاد: {dice_roll}")
    else:
        update.message.reply_text(f"متاسفم! شما باختید. تاس افتاد: {dice_roll}")

def main() -> None:
    # ایجاد و تنظیمات آپدیتر
    updater = Updater(TOKEN)

    # دریافت دیسپیچر برای ثبت دستورات
    dispatcher = updater.dispatcher

    # ثبت دستورات
    dispatcher.add_handler(CommandHandler("start", start))
    dispatcher.add_handler(CommandHandler("play", play))

    # شروع ربات
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()
