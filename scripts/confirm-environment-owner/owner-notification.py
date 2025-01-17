import os
import sys
import argparse
from notifications_python_client.notifications import NotificationsAPIClient

EMAIL_BODY_TEMPLATE = """
Hello,

We are contacting you with a request that you confirm whether the contact details we hold in the tag.owner field for the ((environment)) environment are correct.

The owner email address we have is ((owner)). We will use this should we ever need to contact you regarding the environment.

You can confirm this by either:

- Letting us know using the [#ask-modernisation-platform](https://moj.enterprise.slack.com/archives/C01A7QK5VM1) slack channel, 
- Add a comment to the GitHub [issue](((link))), including the new email address if it has changed.
- Create a PR with the updated email address and contact us via the [#ask-modernisation-platform](https://moj.enterprise.slack.com/archives/C01A7QK5VM1) slack channel and we will review it.

Thank you in advance for taking the time to confirm this information.

Regards, 

Modernisation Platform Team
"""

def send_email(env_name, issue_url, email_address):
    """
    Sends an email notification using the Notify service.
    Args:
        env_name: The name of the environment.
        issue_url: The URL of the issue to include in the email.
        email_address: The email address of the owner.
    """

    api_key = os.environ.get("API_KEY")
    template_id = os.environ.get("TEMPLATE_ID")
    if not api_key or not template_id:
        print("Error: API_KEY and TEMPLATE_ID must be set in environment variables.")
        sys.exit(1)

    client = NotificationsAPIClient(api_key=api_key)

    print("These are the data fields defined in the Notify template which are used in the email:")
    print(env_name)
    print(email_address)
    print(issue_url)

    # Prepare the dynamic subject
    subject = f"Modernisation Platform – Review & confirm owner contact details – {env_name}"

    # This list are the parameters being added which are used by the gov notify template.
    personalisation = {
        "environment": env_name,
        "owner": email_address,
        "link": issue_url,
        "subject": subject,
        "message": EMAIL_BODY_TEMPLATE.replace("((environment))", env_name).replace("((owner))", email_address).replace("((link))", issue_url)
    }

    # Send the email
    try:
        response = client.send_email_notification(
            email_address=email_address,
            template_id=template_id,
            personalisation=personalisation
        )
        print(f"Email successfully sent to {email_address}. Response: {response}")
    except Exception as e:
        print(f"Failed to send email: {e}")
        sys.exit(1)

def main():

    parser = argparse.ArgumentParser(
        description="Send an email using the Notify API, with environment name, issue URL, and the owner email address."
    )
    parser.add_argument("env_name", type=str, help="The environment name (e.g., sprinkler)")
    parser.add_argument("issue_url", type=str, help="The URL of the github issue to include in the email")
    parser.add_argument("email_address", type=str, help="The email address of the owner to send the notification to")

    args = parser.parse_args()

    send_email(args.env_name, args.issue_url, args.email_address)

if __name__ == "__main__":
    main()
