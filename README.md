# Supabase CI/CD pipeline


<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/supabase"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Supabase on Elestio.

<img src="supase_screenshot1.jpg" style='width: 100%;'/>
<br/>
<br/>

# Once deployed ...

You can open Supabase Studio here:

    https://[CI_CD_DOMAIN]:27443/
    Login: root (set in reverse proxy)
    password: [ADMIN_PASSWORD] (set in reverse proxy)

The rest API is available here:

    Base URL: https://[CI_CD_DOMAIN]
    REST API URL: https://[CI_CD_DOMAIN]/rest/v1/


You can deploy multiple instances of Supabase to the same CI/CD target, each instance is a different app with different credentials

# Documentation

    https://supabase.com/docs/guides/api
