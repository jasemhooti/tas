import os
import random
from telegram import Update
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters, CallbackContext

# گرفتن اطلاعات از متغیرهای محیطی
TOKEN = os.getenv("BOT_TOKEN")
ADMIN_ID = os.getenv("ADMIN_ID")

if not TOKEN or not ADMIN_ID:
    print("❌ خطا: لطفاً توکن و آیدی ادمین را در فایل .env وارد کنید.")
    exit()

# دیکشنری برای نگهداری وضعیت کاربران
game_sessions = {}

def start(update: Update, context: CallbackContext) -> None:
    update.message.reply_text("🎲 به بازی تاس خوش آمدید! برای شروع دو نفر باید وارد شوند.\n\nهر کاربری که می‌خواهد بازی کند، دستور /join را ارسال کند.")

def join(update: Update, context: CallbackContext) -> None:
    chat_id = update.message.chat_id
    user_id = update.message.from_user.id

    if chat_id not in game_sessions:
        game_sessions[chat_id] = {"players": [], "number": None}

    if user_id in game_sessions[chat_id]["players"]:
        update.message.reply_text("✅ شما قبلاً به بازی پیوسته‌اید!")
    else:
        game_sessions[chat_id]["players"].append(user_id)
        update.message.reply_text(f"✅ کاربر {update.message.from_user.first_name} به بازی پیوست!")
    
    if len(game_sessions[chat_id]["players"]) == 2:
        game_sessions[chat_id]["number"] = random.randint(1, 6)
        update.message.reply_text("🎲 دو نفر آماده‌اند! عددی بین 1 تا 6 حدس بزنید.")

def guess(update: Update, context: CallbackContext) -> None:
    chat_id = update.message.chat_id
    user_id = update.message.from_user.id

    if chat_id not in game_sessions or len(game_sessions[chat_id]["players"]) < 2:
        update.message.reply_text("⏳ هنوز دو نفر وارد بازی نشده‌اند! از /join استفاده کنید.")
        return

    if user_id not in game_sessions[chat_id]["players"]:
        update.message.reply_text("❌ شما جزو این بازی نیستید! از /join استفاده کنید.")
        return

    try:
        guess_number = int(update.message.text)
    except ValueError:
        update.message.reply_text("⚠️ لطفاً یک عدد بین 1 تا 6 ارسال کنید!")
        return

    if guess_number < 1 or guess_number > 6:
        update.message.reply_text("⚠️ عددی بین 1 تا 6 انتخاب کنید!")
        return

    correct_number = game_sessions[chat_id]["number"]

    if guess_number == correct_number:
        update.message.reply_text(f"🎉 تبریک {update.message.from_user.first_name}! شما برنده شدید. عدد {correct_number} بود!")
        del game_sessions[chat_id]
    else:
        update.message.reply_text("❌ حدس شما اشتباه بود، نفر بعدی حدس بزند.")

def main():
    updater = Updater(TOKEN, use_context=True)
    dp = updater.dispatcher

    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(CommandHandler("join", join))
    dp.add_handler(MessageHandler(Filters.text & ~Filters.command, guess))

    updater.start_polling()
    updater.idle()

if __name__ == "__main__":
    main()
