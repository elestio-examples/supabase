# Supabase CI/CD pipeline

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/supabase"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Supabase on Elestio.

<img src="supase_screenshot1.jpg" style='width: 100%;'/>
<br/>
<br/>

# Once deployed ...

You can open Supabase Studio here:

    https://[CI_CD_DOMAIN]
    Login: root (set in reverse proxy)
    password: [ADMIN_PASSWORD] (set in reverse proxy)

The rest API is available here:

    Base URL: https://[CI_CD_DOMAIN]
    REST API URL: https://[CI_CD_DOMAIN]/rest/v1/

`SUPABASE_KEY` can be found in `./keys.env`

You can deploy multiple instances of Supabase to the same CI/CD target, each instance is a different app with different credentials

# Documentation

    https://supabase.com/docs/guides/api

# Edge Functions

To add a new edge function, go to the VM and create a new folder inside volumes/functions and create a file `index.ts`

You can try it both post and get examples here:

## POST

    curl  -X POST \
        'https://[CI_CD_DOMAIN]/functions/v1/hello' \
        --header 'Accept: */*' \
        --header 'Content-Type: application/json' \
        --data-raw '{
        "name":"root"
        }'

## GET

    curl https://[CI_CD_DOMAIN]/functions/v1/hello

# Edge documentation

    https://supabase.com/docs/guides/functions

# Multi users

This README provides instructions for setting up custom basic authentication for multiple users on the self-hosted version of Supabase. Unlike the cloud version, there isn't email login functionality, but you can easily create custom basic authentication for your users by following the steps below.

## Setup Instructions

Follow these steps to add new users to your Elestio instance:

1. Access Elestio's Dashboard:

- Navigate to your Elestio's dashboard.
- Click on the "Tools" tab.
- Then, click on the "VS Code" button.

2. Locate Configuration File:

- In the opened VS Code interface, locate the volumes>api>kong.yml file.

3. Add New User Credentials:

- Scroll down to the "Dashboard credentials" section within the kong.yml file.
- Below the existing credentials block (which typically contains placeholders like $DASHBOARD_USERNAME and $DASHBOARD_PASSWORD), add a new section for each new user you want to create.
- Each new user section should follow the format:

        - consumer: DASHBOARD
          username: <username>
          password: <password>

4. Example Configuration:

- After adding new user credentials, your kong.yml file might look like this:

        - consumer: DASHBOARD
          username: $DASHBOARD_USERNAME
          password: $DASHBOARD_PASSWORD
        - consumer: DASHBOARD
          username: user2
          password: test1234

5. Restart your stack:

- Open a new terminal window.
- Execute the following commands to restart Elestio with the updated configuration:

        docker-compose down
        docker-compose up -d
