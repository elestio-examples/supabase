#set env vars
set -o allexport; source .env; set +o allexport;

echo "Generating random keys ..."

#this one is read in .env
#JWT_SECRET=homx64qq7dzz12750u8o1rqtw1syj4k9vcj8foew

#10 years expiration
JWT_EXPIRATION_IN_SECONDS=315360000

#define tools functions
base64_urlencode() { openssl enc -base64 -A | tr '+/' '-_' | tr -d '='; }
readonly __entry=$(basename "$0")
log(){ echo -e "$__entry: $*" >&2; }
die(){ log "$*"; exit 1; }


expire_seconds="${JWT_EXPIRATION_IN_SECONDS}"


header='{
    "alg": "HS256",
  	"typ": "JWT"
}'

  payload="{
    \"role\": \"anon\",
    \"iss\": \"supabase\",
    \"iat\": $(date +%s),
    \"exp\": $(($(date +%s)+expire_seconds))
  }"

  header_base64=$(printf %s "$header" | base64_urlencode)
  payload_base64=$(printf %s "$payload" | base64_urlencode)
  signed_content="${header_base64}.${payload_base64}"
  signature=$(printf %s "$signed_content" | openssl dgst -binary -sha256 -hmac "$JWT_SECRET" | base64_urlencode)

  #log "generated JWT token. expires in $expire_seconds seconds -->\\n\\n"
  #printf '%s' "${signed_content}.${signature}"

  JWT_ANON_KEY=${signed_content}.${signature}

  
  #echo $JWT_ANON_KEY
  

  payload="{
    \"role\": \"service_role\",
    \"iss\": \"supabase\",
    \"iat\": $(date +%s),
    \"exp\": $(($(date +%s)+expire_seconds))
  }"

  header_base64=$(printf %s "$header" | base64_urlencode)
  payload_base64=$(printf %s "$payload" | base64_urlencode)
  signed_content="${header_base64}.${payload_base64}"
  signature=$(printf %s "$signed_content" | openssl dgst -binary -sha256 -hmac "$JWT_SECRET" | base64_urlencode)

  
  JWT_SERVICE_KEY=${signed_content}.${signature}
  #echo $JWT_SERVICE_KEY


  #replace vars in .env and ./volumes/api/kong.yml
  sed -i "s/ANON_KEY_RANDOM/$JWT_ANON_KEY/g" .env
  sed -i "s/SERVICE_ROLE_KEY_RANDOM/$JWT_SERVICE_KEY/g" .env
  sed -i "s/ANON_KEY_RANDOM/$JWT_ANON_KEY/g" ./volumes/api/kong.yml
  sed -i "s/SERVICE_ROLE_KEY_RANDOM/$JWT_SERVICE_KEY/g" ./volumes/api/kong.yml 

