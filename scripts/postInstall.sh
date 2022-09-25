#set env vars
set -o allexport; source .env; set +o allexport;

docker-compose down;

echo "Generating random keys ..."
JWT_ANON_KEY=$(JWT_SECRET=$JWT_SECRET node ./scripts/JWT/jwt.js anon);
JWT_SERVICE_KEY=$(JWT_SECRET=$JWT_SECRET node ./scripts/JWT/jwt.js service_role);

sed -i "s/ANON_KEY_RANDOM/$JWT_ANON_KEY/g" ./docker-compose.yml
sed -i "s/SERVICE_ROLE_KEY_RANDOM/$JWT_SERVICE_KEY/g" ./docker-compose.yml
sed -i "s/ANON_KEY_RANDOM/$JWT_ANON_KEY/g" ./volumes/api/kong.yml
sed -i "s/SERVICE_ROLE_KEY_RANDOM/$JWT_SERVICE_KEY/g" ./volumes/api/kong.yml


docker-compose up -d;