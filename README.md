# GitHub App Authentication with Sinatra

This is a Sinatra application that demonstrates how to use a GitHub App for authentication and triggering workflows on GitHub.

## Prerequisites

Before you can use this application, you need to set up a GitHub App on GitHub. Follow the steps below to create and configure your GitHub App:

1. Go to your GitHub account settings and navigate to the **Developer settings** tab.

2. Click on **GitHub Apps** in the left sidebar and then click **New GitHub App**.

3. Fill in the required information for your GitHub App:
   - **GitHub App name**: Enter a name for your app.
   - **Homepage URL**: Provide the URL of your app or a relevant page.
   - **User authorization callback URL**: Enter the URL that GitHub should redirect to after authorizing the app.

4. Configure the permissions and events for your GitHub App:
   - **Permissions**: Choose the necessary permissions your app requires. In this application, the required permissions are `actions`, `contents`, and `metadata`.
   - **Events**: Select the events your app should listen to. For this application, you may choose `push` or other relevant events.

5. Generate and download a private key for your GitHub App:
   - Click on **Generate a private key** to create a new private key in PEM format.
   - Save the private key securely on your local machine.

6. Take note of the following details for your GitHub App:
   - **App ID**: The ID assigned to your GitHub App.
   - **Installation ID**: The ID of the installation of your GitHub App on an account or organization.

## Configuration

To configure this Sinatra application with your GitHub App details:

1. Clone or download this repository to your local machine.

2. Open the `app.rb` file in a text editor.

3. Update the following constants in the code with your GitHub App details:
   - `APP_IDENTIFIER`: Replace with your GitHub App's App ID.
   - `WEBHOOK_SECRET`: Replace with the secret you defined when configuring the webhook.
   - `PRIVATE_KEY_PATH`: Provide the path to the downloaded private key file in PEM format.
   - `INSTALLATION_ID`: Replace with the Installation ID of your GitHub App.
   - `ORG_OWNER`: Replace with the organization or account owner of the repository where the workflow is stored.
   - `REPO_NAME`: Replace with the name of the repository where the workflow is stored.
   - `WORKFLOW_NAME`: Replace with the name of the workflow file (with the YAML extension) to trigger.

4. Save the changes to the `app.rb` file.

## Running the Application

To run the Sinatra application:

1. Ensure you have Ruby installed on your machine.

2. Install the required gems by running the following command in the terminal:

```
$ gem install sinatra json httparty openssl jwt

```

3. In the terminal, navigate to the directory where the `app.rb` file is located.

4. Run the following command to start the Sinatra application:

```
$ ruby app.rb
```

5. The application will start running locally on `http://localhost:4567`.

6. You can set up a webhook in your GitHub repository to forward events to `http://YOUR_PUBLIC_URL/webhook`. Replace `YOUR_PUBLIC_URL` with the publicly accessible URL where your Sinatra application is hosted. Refer to the GitHub documentation for more details on setting up webhooks. To test you could use something like Ngrok. 

7. After receiving a webhook event, the application will verify the signature, extract the required data, and trigger the specified workflow on GitHub.

