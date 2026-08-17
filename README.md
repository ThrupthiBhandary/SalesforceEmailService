# Salesforce Email Service with File Attachments

A Salesforce Apex-based email service that sends transactional emails and optionally attaches files stored in **Salesforce Files**. The project demonstrates how to use Salesforce Apex, `Messaging.SingleEmailMessage`, `ContentVersion`, and `Messaging.EmailFileAttachment` to build a reusable email-sending service.

## Features

* Send simple plain-text emails from Apex
* Send emails with files attached
* Retrieve files from Salesforce Files using their title
* Attach the latest version of a Salesforce File
* Reusable Apex service class
* Handles missing files without preventing the email from being sent
* Uses Salesforce's native email infrastructure

## Technology Stack

* **Salesforce Platform**
* **Apex**
* **Salesforce CLI**
* **VS Code**
* **Salesforce Extension Pack**
* **Salesforce Files / ContentVersion**
* **Git & GitHub**

## Project Structure

```text
SalesforceEmailService/
├── force-app/
│   └── main/
│       └── default/
│           └── classes/
│               ├── MyEmailService.cls
│               └── MyEmailService.cls-meta.xml
│
├── config/
├── manifest/
├── scripts/
│   ├── apex/
│   └── soql/
│
├── .gitignore
├── .forceignore
├── package.json
├── sfdx-project.json
└── README.md
```

## Apex Service

The main class is:

```text
MyEmailService.cls
```

It provides two methods.

### 1. Simple Email

`sendSimpleEmail()` sends a plain-text email without an attachment.

```apex
MyEmailService.sendSimpleEmail(
    'recipient@example.com',
    'Test Email',
    'This is a test email from Salesforce.'
);
```

### 2. Email with File Attachment

`sendEmailWithAttachment()` retrieves a file from Salesforce Files using its title and attaches the latest version to the email.

```apex
MyEmailService.sendEmailWithAttachment(
    'recipient@example.com',
    'Project Submission',
    'Please find the attached document.',
    'MyResume'
);
```

The method uses `ContentVersion` to retrieve the file:

```apex
SELECT Id, Title, VersionData, PathOnClient
FROM ContentVersion
WHERE Title = :fileName
AND IsLatest = true
LIMIT 1
```

The file's binary data is then attached using:

```apex
Messaging.EmailFileAttachment attachment =
    new Messaging.EmailFileAttachment();

attachment.setFileName(fileRecord.PathOnClient);
attachment.setBody(fileRecord.VersionData);
```

## How It Works

```text
Salesforce File
      │
      ▼
ContentVersion
      │
      │ Find file by Title
      ▼
Latest File Version
      │
      │ Retrieve VersionData
      ▼
EmailFileAttachment
      │
      ▼
Messaging.SingleEmailMessage
      │
      ▼
Recipient Email
```

## Setup

### Prerequisites

Make sure you have:

* A Salesforce org
* Salesforce CLI installed
* Visual Studio Code
* Salesforce Extension Pack
* Git
* GitHub account

### Clone the Repository

```bash
git clone https://github.com/ThrupthiBhandary/SalesforceEmailService.git
cd SalesforceEmailService
```

### Authorize Your Salesforce Org

Authenticate your Salesforce org using Salesforce CLI:

```bash
sf org login web --alias MySalesforceOrg --instance-url https://login.salesforce.com --set-default
```

Verify the authorized org:

```bash
sf org list
```

## Deploy to Salesforce

To deploy the project to your Salesforce org:

```bash
sf project deploy start
```

To deploy only the Apex class:

```bash
sf project deploy start --metadata ApexClass:MyEmailService
```

## Retrieve the Apex Class

To retrieve the class from Salesforce into the local project:

```bash
sf project retrieve start --metadata ApexClass:MyEmailService
```

## Uploading a File

Before using `sendEmailWithAttachment()`:

1. Open **Salesforce → Files**.
2. Click **Upload Files**.
3. Select the required document.
4. Upload the file.
5. Check the file's **Title**.
6. Use that exact title as the `fileName` parameter.

For example, if the Salesforce File title is:

```text
DhanyashreeGSuvarnaResume
```

use:

```apex
String targetFileName = 'DhanyashreeGSuvarnaResume';
```

The extension does not necessarily need to be included because the Apex query searches the Salesforce **Title** field.

## Example Execution

The method can be tested using Salesforce's **Execute Anonymous** window:

```apex
String recipient = 'recipient@example.com';

String subject = 'Project Submission with File Attachment';

String body =
    'Please find the attached document requested for the mailing service project.';

String targetFileName = 'MyResume';

MyEmailService.sendEmailWithAttachment(
    recipient,
    subject,
    body,
    targetFileName
);
```

## Error Handling

If the requested Salesforce File cannot be found, the service catches the `QueryException` and logs a warning:

```text
No file found with the name: <fileName>
```

The email can still be sent without the attachment.

For production applications, this behavior can be extended to provide more explicit error handling or return a status to the calling process.

## Email Deliverability

Salesforce email delivery depends on the organization's email configuration.

For testing:

**Setup → Deliverability → Access to Send Email → All Email**

If an email does not appear in the recipient's inbox, check the **Spam/Junk** folder as well as Salesforce email configuration.

## Security Notes

Do not commit personal credentials, passwords, Salesforce access tokens, or sensitive email addresses to GitHub.

For testing code, use placeholders such as:

```apex
'recipient@example.com'
```

rather than personal email addresses.

## Git Workflow

After making changes:

```bash
git status
git add .
git commit -m "Update Salesforce email service"
git push origin main
```

To retrieve the latest changes from GitHub:

```bash
git pull origin main
```

## Future Improvements

Potential enhancements include:

* HTML email support
* Multiple file attachments
* File size validation
* Custom error responses
* Email templates
* Salesforce Org-Wide Email Address support
* Asynchronous email processing
* Unit tests with `@IsTest`
* Support for sending files through public links
* Improved logging and monitoring

## Author

**Thrupthi Bhandary**

Salesforce Apex project demonstrating email automation and Salesforce Files integration.

## License

This project is intended for educational and development purposes.
