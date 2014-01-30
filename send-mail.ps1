param(
    [string]$attachment='',
    [string]$to='', # used to specify the email of the recipient
    [string]$cc='', # used to specify the email of the recipient of a copy of the mail
    [string]$bcc='', # used to specify the email of the recipient of a blind copy of the mail*
    [string]$subject='', # subject of the mail
    [string]$body='', # body of the mail
    [string]$exec='' # mail client, if not default type path to Thunderbird installation, eg. C:\Program Files (x86)\Mozilla\Thunderbird\thunderbird.exe
    )

# ------ Get default mail client -------

if ($exec) {
    $MailClient = $exec + "-compose `"%1`""
}
else {
    $node = Get-ItemProperty HKCU:\Software\Classes\mailto\shell\open\command
    if (!$node) {
          $node = Get-ItemProperty HKLM:\Software\Classes\mailto\shell\open\command
    }

    $MailClient = $node.'(default)'
}
# TODO check if default client is compatible

# ------ Read email fields -------------

$cmdParams = New-Object Collections.Generic.List[string]

$emailFields = @{"to"=$to; "cc"=$cc; "bcc"=$bcc; "subject"= $subject; "body" = $body}

$emailFields.Keys | % {     $value = $emailFields[$_] 
    if ($value) {    
        $cmdParams.Add("$_=`'$value`'");
     }

}

# Assign ATTACHMENTS
if ($attachment) {

    if (Test-Path($attachment)) {
        $fullPath = (Get-Item $attachment).FullName;
        $cmdParams.Add("attachment=`'$fullPath`'"); 
        
    } else {
        echo "The path `"$file`" does not exists."
    }
} elseif (@($input).Count -gt 0) {
    # Try to assign ATTACHMENTS parameter from pipeline 
    $input.reset()
    $attachParam = "attachment=`'"
    foreach ($filename in $input) {
         $fullPath = $filename.FullName + ","
         $attachParam += $fullPath
    }

    $attachParam += "`'"
    $cmdParams.Add($attachParam)
}


# ----- Build & run command -------------

$command = ''

if ($cmdParams.Count -gt 0) {
    foreach ($param in $cmdParams) {
            $command += $param + ","
    }
}

$command = $MailClient -replace "`%1", $command

Invoke-Expression "& $command"