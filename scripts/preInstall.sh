#set env vars
set -o allexport; source .env; set +o allexport;

apt install nodejs npm -y
npm install --prefix ./scripts/JWT/ jsonwebtoken@8.5.1

echo "Generating random keys ..."
JWT_ANON_KEY=$(JWT_SECRET=$JWT_SECRET node ./scripts/JWT/jwt.js anon);
JWT_SERVICE_KEY=$(JWT_SECRET=$JWT_SECRET node ./scripts/JWT/jwt.js service_role);

sed -i "s/ANON_KEY_RANDOM/$JWT_ANON_KEY/g" ./volumes/api/kong.yml
sed -i "s/SERVICE_ROLE_KEY_RANDOM/$JWT_SERVICE_KEY/g" ./volumes/api/kong.yml


echo "SUPABASE_ANON_KEY=$JWT_ANON_KEY" >> ./keys.env
echo "SUPABASE_SERVICE_KEY=$JWT_SERVICE_KEY" >> ./keys.env
echo "ANON_KEY=$JWT_ANON_KEY" >> ./keys.env
echo "SERVICE_KEY=$JWT_SERVICE_KEY" >> ./keys.env
