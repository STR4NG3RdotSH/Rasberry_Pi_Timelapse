# Summary
This bot is fully written in linux shell (`.sh scripting`) and will run natively on most systems. Developed and running on a RaspberryPI and has been feeding discord servers memes for over a year. The only dependency that is in place is using sqlite by preference, although you can tweak the code to simply store your servers/webhooks in a text file if you'd rather not install sqlite.

# Where do the memes get sourced from?
Various places, mostly REDDIT. You can see exact sources and how they are sourced in the script.
`memedroid (x1) imgflip (x1) reddit (x5)`

# Bugs?
The only bug I haven't been able to squash (haven't bothered tbh) is every once in a while, despite my meager efforts, a meme will slip through that has already been used. Usually when flow is slow.

# Can I see the bot in action?
Yea, the bot is currently feeding many servers, but you can see it in action on my discord server ([DISCORD.D4NG3R.COM](https://discord.d4ng3r.com)) in `BOT FEEDS > #meme-stream` at quality flow.

# Usage 
(Under the assumption you installed sqlite and have created a database structured like `DiscordBotDB.png`)
- Ensure you add your discord webhook URL to your sqlite db (See `DiscordBotDB.png`)
- Pull the SH script to your run location (I just run it from user folder `/home/<user>/projects/discord_bots/memes` but you can run it from anywhere.)
- Set the `hooks` var (line 4) to specify DB/Table/Data selections
- Set the `bot_files` var (line 8), this tells the bot where to cache used URLs
- Set the `flow` var (Possible values are `quality` and `quantity`. Difference is top current memes vs latest posted memes. `quantity` will result in heavy flow of mostly poorly slapped together unfunny memes.)
- Set the bot to run however you like. I have it set to run every 5 minutes via CRON (Example below)
-- Cron file: `/etc/cron.d/run_all_discord_bots`
-- Cron file contents: `*/5 * * * * root /home/admin/projects/discord_bots/memes/bot_memes.sh`

***NOTE: If using sqlite, see `DiscordBotDB.png` for table structure this bot expects

# History
I developed my discord bots after KITROBIT stopped providing their services and ran a small PATREON page to generate support. I recently disabled patreon income and decided to just generalize my code and upload to GITHUB. I may tweak them over time as they all run 24/7 for various discord servers right now. If you make any positive tweaks/changes/fixes please let me know to update these repositories. 

# Buy me a beer?
Feel free to paypal me a couple bucks for a beer! `str4ng3r 4t d4ng3r d0t com`
