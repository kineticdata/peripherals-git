# Repo Copy Template

## Parameters
[Error Handling]
  Select between returning an error message, or raising an exception.
[Source Repository]
  https url for the repository to clone.
[Destination Repository]
  https url for the repository to push to.

## Results
[Handler Error Message]
  An inspection of the Exception error

### Notes
  * It is assumed that the user has rights to both the source and destination urls.
  * To support GitHubs Personal Access Token (PAT) authentication the username has is encrypted and the password is optional.  To authenticate to Github for repo push/pull place the PAT into the username field and leave the password field blank.
