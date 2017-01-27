# Newsbot
Newsbot is a script that caches the full text of the top 10 articles being syndicated on several large news organization's RSS feeds. These articles are converted to a simple html representation and this html is archived. The script is designed to be called on a web server periodically by a cron job to get the latest snapshot. The snapshot html files are placed in a web accessible location for browsing. The archive is stored in a seperate history folder.

## Setup
Note: It's highly recommended to set this up on a cloud VPS that provides a canned LAMP or LEMP stack. These instructions cover setup using DigitalOcean, but it should be similar on Lightsail or similar services.
* Create a LEMP droplet on DigitalOcean. The smallest size is (more than) adequate.
* Log in to the droplet via SSH.
* Run `apt-get update`.
* Run `apt-get install php-xml php-mbstring php-tidy php-cli php-cgi xsltproc`.
* Navigate to var by the webroot by running `cd /var`
* Move the default webroot folder by running `mv www www_default`
* Run this command to clone this repo into the webroot: `git clone https://github.com/xtruan/newsbot.git www`
* Mark the newsbot script as executable: `chmod +x www/newsbot.sh`
* Set up cron to execute the script on an interval, run `crontab -e` and set the line to something like `*/30 * * * * /var/www/newsbot.sh`. This will execute the script every 30 mins.
