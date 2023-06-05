// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.177.1/http/server.ts";

async function getMessage() {
  const data = {
    message: `Hello from Supabase Edge Functions!`,
  };

  return new Response(JSON.stringify(data), {
    headers: { "Content-Type": "application/json", Connection: "keep-alive" },
  });
}

async function postMessage(req: Request) {
  const { name }: reqPayload = await req.json();
  const data = {
    message: `Hello ${name} from Supabase Edge Functions!`,
  };

  return new Response(JSON.stringify(data), {
    headers: { "Content-Type": "application/json", Connection: "keep-alive" },
  });
}

serve(async (req: Request) => {
  const { url, method } = req;

  if (method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // call relevant method based on method and id
  switch (true) {
    case method === "GET":
      return getMessage();
    case method === "POST":
      return postMessage(req);
    default:
      return getMessage();
  }
});
