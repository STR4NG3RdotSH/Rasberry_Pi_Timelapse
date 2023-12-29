#!/bin/bash

#Collect webhooks from sqlite database
hooks=$(sqlite3 /home/admin/projects/discord_bots/hooks.db "select discord_webhook from clients where source like 'memes' and enabled = 'yes';")
echo $hooks

#Set temp file location
bot_files="/home/admin/projects/discord_bots/memes"

#Enable/Disable showing URL in discord post (1=on, 0=off)
show_url="0"

#Toggle quality vs quantity (Occassional good meme vs endless flow of highly likely unfunny memes)
flow="quality" #(possible values: quality/quantity)

#Pull and isolate latest meme: memedroid
if [ "$flow" = "quality" ]; then
        wget -L "https://www.memedroid.com/memes/top/day" -O $bot_files/memedroid_dump
    else
        wget -L "https://www.memedroid.com/memes/latest" -O $bot_files/memedroid_dump
fi
cat $bot_files/memedroid_dump | grep -Eo "(http|https)://(images|rvideos)[a-zA-Z0-9./?=_%:-]*(jpeg|webm|webp)" | uniq > $bot_files/memedroid_urlcache
memedroid_url=$(head -n 1 $bot_files/memedroid_urlcache)
memedroid_oldurl=$(head -n 1 $bot_files/memedroid_oldurl)

#Pull and isolate latest meme: imgflip
if [ "$flow" = "quality" ]; then
        wget -L "https://imgflip.com/tag/memes?sort=hot" -O $bot_files/imgflip_dump
    else
        wget -L "https://imgflip.com/tag/memes?sort=latest" -O $bot_files/imgflip_dump
fi
cat $bot_files/imgflip_dump | grep -Eo "//(i.imgflip.com)[a-zA-Z0-9./?=_%:-]*(jpg|gif|jpeg|png)" | uniq > $bot_files/imgflip_urlcache
sed -i 's%//i.%https://i.%' $bot_files/imgflip_urlcache
sed -i '/^.\{33,\}$/d' $bot_files/imgflip_urlcache
imgflip_url=$(head -n 1 $bot_files/imgflip_urlcache)
imgflip_oldurl=$(head -n 1 $bot_files/imgflip_oldurl)

#Pull and isolate latest meme: reddit/r/memes
if [ "$flow" = "quality" ]; then
        wget -L "https://www.reddit.com/r/memes/hot.rss" -O $bot_files/redditrmemes_dump
    else
        wget -L "https://www.reddit.com/r/memes/new.rss" -O $bot_files/redditrmemes_dump
fi
cat $bot_files/redditrmemes_dump | grep -Eo "//(i.redd.it)[a-zA-Z0-9./?=_%:-]*(jpg|gif|png|jpeg)" | uniq > $bot_files/redditrmemes_urlcache
redditrmemes_url="https:$(head -n 1 $bot_files/redditrmemes_urlcache)"
redditrmemes_oldurl=$(head -n 1 $bot_files/redditrmemes_oldurl)

#Pull and isolate latest meme: reddit/r/dankmemes
if [ "$flow" = "quality" ]; then
        wget -L "https://www.reddit.com/r/dankmemes/hot.rss" -O $bot_files/redditrdankmemes_dump
    else
        wget -L "https://www.reddit.com/r/dankmemes/new.rss" -O $bot_files/redditrdankmemes_dump
fi
cat $bot_files/redditrdankmemes_dump | grep -Eo "//(i.redd.it)[a-zA-Z0-9./?=_%:-]*(jpg|gif|png|jpeg)" | uniq > $bot_files/redditrdankmemes_urlcache
redditrdankmemes_url="https:$(head -n 1 $bot_files/redditrdankmemes_urlcache)"
redditrdankmemes_oldurl=$(head -n 1 $bot_files/redditrdankmemes_oldurl)

#Pull and isolate latest meme: reddit/r/meme
if [ "$flow" = "quality" ]; then
        wget -L "https://www.reddit.com/r/meme/hot.rss" -O $bot_files/redditrmeme_dump
    else
        wget -L "https://www.reddit.com/r/meme/new.rss" -O $bot_files/redditrmeme_dump
fi
cat $bot_files/redditrmeme_dump | grep -Eo "//(i.redd.it)[a-zA-Z0-9./?=_%:-]*(jpg|gif|png|jpeg)" | uniq > $bot_files/redditrmeme_urlcache
redditrmeme_url="https:$(head -n 1 $bot_files/redditrmeme_urlcache)"
redditrmeme_oldurl=$(head -n 1 $bot_files/redditrmeme_oldurl)

#Pull and isolate latest meme: reddit/r/musicmemes
if [ "$flow" = "quality" ]; then
        wget -L "https://www.reddit.com/r/musicmemes/hot.rss" -O $bot_files/redditrmusicmemes_dump
    else
        wget -L "https://www.reddit.com/r/musicmemes/new.rss" -O $bot_files/redditrmusicmemes_dump
fi
cat $bot_files/redditrmusicmemes_dump | grep -Eo "//(i.redd.it)[a-zA-Z0-9./?=_%:-]*(jpg|gif|png|jpeg)" | uniq > $bot_files/redditrmusicmemes_urlcache
redditrmusicmemes_url="https:$(head -n 1 $bot_files/redditrmusicmemes_urlcache)"
redditrmusicmemes_oldurl=$(head -n 1 $bot_files/redditrmusicmemes_oldurl)

#Pull and isolate latest meme: reddit/r/wholesomememes
if [ "$flow" = "quality" ]; then
        wget -L "https://www.reddit.com/r/wholesomememes/hot.rss" -O $bot_files/redditrwholesomememes_dump
    else
        wget -L "https://www.reddit.com/r/wholesomememes/new.rss" -O $bot_files/redditrwholesomememes_dump
fi
cat $bot_files/redditrwholesomememes_dump | grep -Eo "//(i.redd.it)[a-zA-Z0-9./?=_%:-]*(jpg|gif|png|jpeg)" | uniq > $bot_files/redditrwholesomememes_urlcache
redditrwholesomememes_url="https:$(head -n 1 $bot_files/redditrwholesomememes_urlcache)"
redditrwholesomememes_oldurl=$(head -n 1 $bot_files/redditrwholesomememes_oldurl)

#Check if show_url is enabled:
if [ "$show_url" = "1" ]; then
        addstr=" : "
    else
        addstr=""
fi

#If usedurls file doesn't exist, create it
        if [[ ! -e $bot_files/usedurls ]]; then
                touch $bot_files/usedurls
        fi

#Dump latest meme from each source into each listed discord webhook (URL array at top)
for str in ${hooks[@]}; do
if [ "$memedroid_url" != "$memedroid_oldurl" ]; then
        if ! grep -q "$memedroid_url" $bot_files/usedurls; then
                curl -d "{\"content\": \"$memedroid_url$addstr\"}" -H "Content-Type: application/json" "$str"
                (echo "$memedroid_url" && cat $bot_files/usedurls) > $bot_files/usedurls.temp && mv $bot_files/usedurls.temp $bot_files/usedurls
        fi
fi
if [ "$imgflip_url" != "$imgflip_oldurl" ]; then
        if ! grep -q "$imgflip_url" $bot_files/usedurls; then
                curl -d "{\"content\": \"$imgflip_url$addstr\"}" -H "Content-Type: application/json" "$str"
                (echo "$imgflip_url" && cat $bot_files/usedurls) > $bot_files/usedurls.temp && mv $bot_files/usedurls.temp $bot_files/usedurls
        fi
fi
if [ "$redditrmemes_url" != "$redditrmemes_oldurl" ]; then
        if ! grep -q "$redditrmemes_url" $bot_files/usedurls; then
                curl -d "{\"content\": \"$redditrmemes_url$addstr\"}" -H "Content-Type: application/json" "$str"
                (echo "$redditrmemes_url" && cat $bot_files/usedurls) > $bot_files/usedurls.temp && mv $bot_files/usedurls.temp $bot_files/usedurls
        fi
fi
if [ "$redditrdankmemes_url" != "$redditrdankmemes_oldurl" ]; then
        if ! grep -q "$redditrdankmemes_url" $bot_files/usedurls; then
                curl -d "{\"content\": \"$redditrdankmemes_url$addstr\"}" -H "Content-Type: application/json" "$str"
                (echo "$redditrdankmemes_url" && cat $bot_files/usedurls) > $bot_files/usedurls.temp && mv $bot_files/usedurls.temp $bot_files/usedurls
        fi
fi
if [ "$redditrmeme_url" != "$redditrmeme_oldurl" ]; then
        if ! grep -q "$redditrmeme_url" $bot_files/usedurls; then
                curl -d "{\"content\": \"$redditrmeme_url$addstr\"}" -H "Content-Type: application/json" "$str"
                (echo "$redditrmeme_url" && cat $bot_files/usedurls) > $bot_files/usedurls.temp && mv $bot_files/usedurls.temp $bot_files/usedurls
        fi
fi
if [ "$redditrmusicmemes_url" != "$redditrmusicmemes_oldurl" ]; then
        if ! grep -q "$redditrmusicmemes_url" $bot_files/usedurls; then
                curl -d "{\"content\": \"$redditrmusicmemes_url$addstr\"}" -H "Content-Type: application/json" "$str"
                (echo "$redditrmusicmemes_url" && cat $bot_files/usedurls) > $bot_files/usedurls.temp && mv $bot_files/usedurls.temp $bot_files/usedurls
        fi
        fi
if [ "$redditrwholesomememes_url" != "$redditrwholesomememes_oldurl" ]; then
        if ! grep -q "$redditrwholesomememes_url" $bot_files/usedurls; then
                curl -d "{\"content\": \"$redditrwholesomememes_url$addstr\"}" -H "Content-Type: application/json" "$str"
                (echo "$redditrwholesomememes_url" && cat $bot_files/usedurls) > $bot_files/usedurls.temp && mv $bot_files/usedurls.temp $bot_files/usedurls
        fi
fi

#Make sure our used url cache never exceeds 100 lines (Disk space saver)
while [[ $(cat $bot_files/usedurls | wc -l) > 100 ]] #While usedurls has more than 100 lines
do
        sed -i '$ d' $bot_files/usedurls #Remove last line in file
done #Close url cache cleaning while loop

done #Close discord delivery for loop

#Set cached URLs to old urls to ensure the same meme's don't get repeatedly added to discord channels
if [ "$memedroid_url" != "$memedroid_oldurl" ]; then
    echo "$memedroid_url" > $bot_files/memedroid_oldurl
fi
if [ "$imgflip_url" != "$imgflip_oldurl" ]; then
    echo "$imgflip_url" > $bot_files/imgflip_oldurl
fi
if [ "$redditrmemes_url" != "$redditrmemes_oldurl" ]; then
    echo "$redditrmemes_url" > $bot_files/redditrmemes_oldurl
fi
if [ "$redditrdankmemes_url" != "$redditrdankmemes_oldurl" ]; then
    echo "$redditrdankmemes_url" > $bot_files/redditrdankmemes_oldurl
fi
if [ "$redditrmeme_url" != "$redditrmeme_oldurl" ]; then
    echo "$redditrmeme_url" > $bot_files/redditrmeme_oldurl
fi
if [ "$redditrmusicmemes_url" != "$redditrmusicmemes_oldurl" ]; then
    echo "$redditrmusicmemes_url" > $bot_files/redditrmusicmemes_oldurl
fi
if [ "$redditrwholesomememes_url" != "$redditrwholesomememes_oldurl" ]; then
    echo "$redditrwholesomememes_url" > $bot_files/redditrwholesomememes_oldurl
fi
