
var roleName = process.argv[2];

var JWT_SECRET = process.env.JWT_SECRET;
var jwt = require('jsonwebtoken');
var payload = {
    "role": roleName,
    "iss": "supabase"
}
var token = jwt.sign(payload, JWT_SECRET, { expiresIn: 60 * 60 * 24 * 365 * 10 });
console.log(token);