Common utility scripts in Powershell
====================================

send-mail - sending e-mails via Thunderbird
--------------------------------------------

This script allows to open a compose window of Mozilla Thunderbird or other apps based on MT (such as Postbox) using most of the parameters described at http://kb.mozillazine.org/Command_line_arguments_(Thunderbird) in section _Compose new mail with command line_

### Usage

Open an **empty** compose window
```
send-mail
```

Specify **to** field

```
send-mail -to abc@example.com
```

Adding **attachments** can be performed in two ways:

1) via named parameter:

```
send-mail -attachment sample_file.txt
```

2) via pipe - in this case many files can be attached as shown below:

```
ls *.pdf | send-mail
```

