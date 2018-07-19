# Telnyx IVR Example

## Telnyx Call Control

<a href="http://www.youtube.com/watch?feature=player_embedded&v=1rg5iawJapw
" target="_blank"><img src="http://img.youtube.com/vi/1rg5iawJapw/0.jpg"
alt="Telnyx Call Control" width="240" height="180" border="10" /></a>

[Call Control Introduction (video)](https://www.youtube.com/watch?v=1rg5iawJapw&t=16s)

## How it works?

This application demonstrates a simple interactive voice response (IVR) system,
built using the call control features of Telnyx's API. Call control is
essentially a collection of commands that can be triggered by your application
and events that occur on the call as a result of actions of the caller or callee
or of a command.

This IVR represents a flow with which we are all familiar: the customer places
a call to a company which is immediately answered and an audio menu is played to
the caller allowing them to select the department they need from a list.

Using call control that flow looks like:

1. Receive a `Call Initiated` event. This will occur when we receive a call
to a number associated with a call control connection.
2. Issue an `Answer Call` command, instructing call control to answer the
call.
3. Receive a `Call Answered` event, verifying the call has been answered.
4. Issue a `Gather` command, playing our audio menu to the caller and
instructing them to select an option by pressing a digit.
5. Caller press a digit.
6. Receive a `Gather Ended` event containing the pressed digit.
7. Perform an action based on the digit pressed by the caller:
	* if the digit is `1`, the call is transfered to our imaginary support number
	* if the digit is `2`, hangup the call
	* if any other digit is pressed, return to `step 4` and replay the audio menu.

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc.

If you want to deploy on heroku you also need to have installed and
configured the [heroku cli](https://devcenter.heroku.com/articles/heroku-cli).

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

or by exporting the environment variables and running:

    % rails s

## Setting up Call Control

Now that you have the repo downloaded and dependencies installed, you need to
set up a call control connection and associate a telephone number and outbound
profile with that connection.

You can set these up using the [Telnyx Mission Control Portal](https://portal.telnyx.com) or
using the API by following the instructions in the
[Telnyx Developer Docs](https://developers.telnyx.com/docs/call-control).

## Configuration
In order to use the Telnyx API the following environment variables must be
present. You can find these credential in the [Mission Control Portal](https://portal.telnyx.com)
under the Auth section.

```
TELNYX_API_KEY=my-telnyx-access-key
TELNYX_API_SECRET=my-telnyx-token
```

You also need to set the `SUPPORT_PHONE_NUMBER` environment variable which will
be the number of the support department in the IVR. If the caller selects the
support option from the audio menu, the call will be transfered to this number.

You may also specify a custom file for the audio menu by setting the
`IVR_MENU_URL` environment variable. This url must point to a publicly
accessible audio file of either `.wav` or `.mp3` format.

### Example

```
IVR_MENU_URL=https://9999999.ngrok.io/files/ivr_menu
SUPPORT_PHONE_NUMBER=+19999999999
```

For local development we recommend setting these values in the `.env` file. This file is
created by copying the dev.env file when you run `./bin/setup`.
Values in this file will be automatically exported when you use `heroku local`,
If you're not using heroku we recommend using [forego](https://github.com/ddollar/forego)
to export your environment variables by running `forego run rails s`.

We strongly recommend you DO NOT commit changes to this file to source control
as this could expose your credentials if your source control service is compromised.

## Running locally
If running the application locally, you will need to expose your application via a tunnel, so
that we can send you the events that occur on the call. To do this you can use a tool like
[ngrok](https://ngrok.com/).

NOTE: This setup should only be used while developing your applicaton. Once you're
ready for production you'll want to deploy your application to a server in the cloud.
An easy way to do this is via Heroku, instructions for which are included in
[Deploying to Heroku](#deploying-to-heroku) below.

1. Start the tunneling service pointing the tunnel to your application
running locally. By default Rails accepts requests on port 3000 so in the example below we are
creating a tunnel to port 3000.

```
./ngrok http 3000
```

This will open a tunnel from ngroks server to whatever is running on your localhost on port 3000,
in this case your call control application.

2. Copy the HTTPS URL displayed in the ngrok session status screen. It will look something
like this: `https://0eff6122.ngrok.io`.

3. Edit your connection's call control Webhook URL pasting in the URL copied from the ngrok config
and appening `/events`. This tells call control to send events received on this connection to
the ngrok URL that will in turn forward the request to your locally running application.

4. You will also need to use the ngrok URL in an environment variable pointing to your ivr menu recording.
To do this open the `.env` file and edit the IVR_MENU_URL entry to be the ngrok URL with `/files/ivr_menu`
appended.

    ```
    IVR_MENU_URL=https://9999999.ngrok.io/files/ivr_menu
    ```

Be sure to restart your application after editing the environment file.

This value will be used as the URL of the recording to playback for the IVR menu.
We've included a basic one, but you can easily replace with your own.


If you have associated a phone number to your connection you should now be able to call that number
and see events arriving at your local application.

## Deploying to Heroku

### Quick Deploy
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

1. Input a unique app name
2. Copy the app name into APP_NAME
3. Copy your API Key and Secret from the Mission Control Portal
4. Set the support phone number in +E164 format (don't use the same number you are using to call the IVR)
5. Click Deploy App
6. Once deployed click Manage App -> Settings
7. Copy the domain name shown under Domains and Certificates
8. Append `/events` to the URL and set it as the webhook URL of your call control connection

### Staging

If you have previously run the `./bin/setup` script,
run the `./bin/setup_heroku` script to create the staging Heroku App.
You can deploy to staging:

    % ./bin/deploy staging

### Production

To deploy to production `export ENVIRONMENT=production` and run the `./bin/setup_heroku`
again then run:

    % ./bin/deploy production

### Post deploy setup

Run `heroku info -s | grep web_url | cut -d= -f2`. This is the URL of your application running on Heroku.
Append `/events` to the URL and set this as the callback URL on your call control connection. You can do
this through the [Mission Control Portal](https://portal.telnyx.com).

## Troubleshooting

### Could not connect to server

If you are seeing this error and you are certain postgres is running locally,
```
could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/var/pgsql_socket/.s.PGSQL.5432"?
```

or if you want to connect to postgres without using a Unix socket, uncomment the line in the `.env` file
that specifies `PGHOST=localhost`. You may also need to set `PGUSER=user` and `PGPASSWORD=password` to
your postgres username and password.
