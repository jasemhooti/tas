import logging
import random
from telegram import Update
from telegram.ext import Updater, CommandHandler, MessageHandler, filters, CallbackContext

# تنظیمات لاگینگ برای نمایش ارورها در کنسول
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)
logger = logging.getLogger(__name__)

# تابع شروع که دستور `/start` رو پردازش می‌کند
def start(update: Update, context: CallbackContext) -> None:
    update.message.reply_text('سلام! برای بازی تاس دو نفره به من عدد بگو.')

# تابع بازی که برای حدس تاس انجام می‌شود
def play_dice(update: Update, context: CallbackContext) -> None:
    try:
        # دریافت عدد حدس زده شده از کاربر
        user_guess = int(update.message.text)

        # پرتاب تاس
        dice_roll = random.randint(1, 6)

        # مقایسه حدس کاربر با عدد پرتاب شده
        if user_guess == dice_roll:
            update.message.reply_text(f'تبریک! شما برنده شدید! تاس پرتاب شده: {dice_roll}')
        else:
            update.message.reply_text(f'متاسفم! شما بازنده شدید. تاس پرتاب شده: {dice_roll}')
    except ValueError:
        update.message.reply_text('لطفا یک عدد صحیح وارد کنید.')

# تابع اصلی که همه‌ی دستورات و پیام‌ها رو مدیریت می‌کند
def main():
    # توکن ربات تلگرام (توکن رو با توکن واقعی خود جایگزین کنید)
    TOKEN = '6414210268:AAEL-RZiABoMzS_QY922hOQnpXcam9OgiF0'

    # ایجاد updater و dispatcher برای مدیریت درخواست‌ها
    updater = Updater(TOKEN)

    # دریافت dispatcher برای اضافه کردن هندلرها
    dispatcher = updater.dispatcher

    # هندلر برای دستور /start
    dispatcher.add_handler(CommandHandler("start", start))

    # هندلر برای دریافت پیام‌های متنی از کاربر و شروع بازی
    dispatcher.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, play_dice))

    # شروع ربات
    updater.start_polling()

    # انجام مداوم در پس‌زمینه
    updater.idle()

if __name__ == '__main__':
    main()
