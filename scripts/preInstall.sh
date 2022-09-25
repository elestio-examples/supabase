#set env vars
set -o allexport; source .env; set +o allexport;
apt install nodejs npm -y

npm install --prefix ./scripts/JWT/ jsonwebtoken

echo "Generating random keys ..."
JWT_ANON_KEY=$(JWT_SECRET=$JWT_SECRET node ./scripts/JWT/jwt.js anon);
JWT_SERVICE_KEY=$(JWT_SECRET=$JWT_SECRET node ./scripts/JWT/jwt.js service_role);

#replace vars in .env and ./volumes/api/kong.yml
sed -i "s/ANON_KEY_RANDOM/$JWT_ANON_KEY/g" .env
sed -i "s/SERVICE_ROLE_KEY_RANDOM/$JWT_SERVICE_KEY/g" .env
sed -i "s/ANON_KEY_RANDOM/$JWT_ANON_KEY/g" ./volumes/api/kong.yml
sed -i "s/SERVICE_ROLE_KEY_RANDOM/$JWT_SERVICE_KEY/g" ./volumes/api/kong.yml