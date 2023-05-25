require 'sinatra'
require 'json'
require 'httparty'
require 'openssl'
require 'jwt'
require 'pry'

# GitHub App configuration
APP_IDENTIFIER = 4
WEBHOOK_SECRET = 'your-webhook-secret'
PRIVATE_KEY_PATH = './add-all-members.2023-05-18.private-key.pem'
INSTALLATION_ID = '4'
# Repository and workflow details
REPO_OWNER = 'manchester-united-org'
REPO_NAME = 'add-employees-to-team'
WORKFLOW_NAME = 'main.yml'

# POST route to handle the webhook
post '/webhook' do
  request.body.rewind
  payload_body = request.body.read
  verify_signature(payload_body, request.env['HTTP_X_HUB_SIGNATURE'])

  payload = JSON.parse(payload_body)
  action = payload['action']
  # Extract any required data from the payload for your workflow
  puts payload
  trigger_workflow(payload)

  status 200
end

# Method to verify the webhook signature
def verify_signature(payload_body, signature_header)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), WEBHOOK_SECRET, payload_body)
  halt 401 unless Rack::Utils.secure_compare(signature, signature_header)
end

# Method to trigger the workflow using GitHub API
def trigger_workflow(payload)

# Load the private key
private_key = OpenSSL::PKey::RSA.new(File.read(PRIVATE_KEY_PATH))

# Create the JWT 
  jwt_payload = {
    iat: Time.now.to_i,
    exp: Time.now.to_i + (10 * 60), # Set expiration time to 10 minutes from now
    iss: APP_IDENTIFIER
  }
  jwt_token = JWT.encode(jwt_payload, private_key, 'RS256')

  # Request the installation access token
  installation_access_token = request_installation_access_token(jwt_token)

  # Trigger the workflow
  endpoint = "https://ghes-gusshawstewart.uksouth.cloudapp.azure.com/api/v3/repos/#{REPO_OWNER}/#{REPO_NAME}/actions/workflows/#{WORKFLOW_NAME}/dispatches"

  headers = {
    'Authorization' => "Bearer #{installation_access_token}",
    'Content-Type' => 'application/json'
  }

  body = {
    ref: 'main',
    inputs: {
      login: payload['user']['login']
    }
  }

  response = HTTParty.post(endpoint, headers: headers, body: body.to_json)
  puts response.code
end

# Method to request the installation access token
def request_installation_access_token(jwt_token)
  url = "https://ghes-gusshawstewart.uksouth.cloudapp.azure.com/api/v3/app/installations/#{INSTALLATION_ID}/access_tokens"

  headers = {
    'Accept' => 'application/vnd.github+json',
    'Authorization' => "Bearer #{jwt_token}"
  }

  response = HTTParty.post(url, headers: headers)

  # Process the response
  if response.code == 201
    parsed_response = JSON.parse(response.body)
    parsed_response['token']
  else
    puts "Error: #{response.body}"
  end
end
