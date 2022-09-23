#set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for WP to be ready ...";
sleep 20s;

#Create default user
wp_target=$(docker-compose port wordpress 80)
curl http://$wp_target/wp-admin/install.php?step=2 \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36' \
  -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
  --data-raw 'weblog_title=Wordpress&user_name='"$ADMIN_EMAIL"'&admin_password='"$ADMIN_PASSWORD"'&admin_password2='"$ADMIN_PASSWORD"'&admin_email='"$ADMIN_EMAIL"'&Submit=Install+WordPress&language=' \
  --compressed;

#fix wp-config to allow multi domains
sed -i '/define(/i \
define("WP_SITEURL", "https://" . $_SERVER["HTTP_HOST"]);\
define("WP_HOME", "https://" . $_SERVER["HTTP_HOST"]);' ./wordpress/wp-config.php


#install wp-cli + plugins
cat << EOF > ./installWP-CLI.sh
#install wp-cli
docker-compose exec -T wordpress bash -c "cd /tmp/ && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp;"

#install plugins
docker-compose exec -T wordpress bash -c "wp plugin install wp-super-cache --activate --allow-root --path='/var/www/html'"
docker-compose exec -T wordpress bash -c "wp plugin install wordpress-seo --activate --allow-root --path='/var/www/html'"
#docker-compose exec -T wordpress bash -c "wp plugin install elementor --activate --allow-root --path='/var/www/html'"
docker-compose exec -T wordpress bash -c "wp plugin install contact-form-7 --activate --allow-root --path='/var/www/html'"

#set permissions
sudo chown -R www-data:www-data ./wordpress;

EOF
chmod +x ./installWP-CLI.sh;

#install now wp-cli and plugins: 
echo "Installing WP CLI & default plugins ...";
./installWP-CLI.sh;