param(
    [string]$attachment='',
    [string]$to='', # used to specify the email of the recipient
    [string]$cc='', # used to specify the email of the recipient of a copy of the mail
    [string]$bcc='', # used to specify the email of the recipient of a blind copy of the mail*
    [string]$subject='', # subject of the mail
    [string]$body='', # body of the mail
    [string]$exec = 'C:\Program Files (x86)\Postbox\postbox.exe'
    )

$cmdBeginning = "& `"$exec`" -compose "

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
         echo $fullPath
         $attachParam += $fullPath
    }

    $attachParam += "`'"
    $cmdParams.Add($attachParam)
}


# ----- Build & run command -------------

$command = $cmdBeginning;

if ($cmdParams.Count -gt 0) {
    $command += "`""
    foreach ($param in $cmdParams) {
            $command += $param + ","
    }
    $command += "`""
}

Invoke-Expression $command;