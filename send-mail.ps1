# TODO add other options available by Thunderbird or Postbox
# The full list is available at http://kb.mozillazine.org/Command_line_arguments_(Thunderbird)
# TODO allow to get many attachments via pipe, eg. ls *.txt | send-mail.ps1
param(
    [string]$to="None",
    [string]$attachment="None",
    [string]$exec = 'C:\Program Files (x86)\Postbox\postbox.exe'
    )

$commandBegin = "& `"$exec`" -compose "


$params = New-Object Collections.Generic.List[string]


if (!($to.Equals("None"))) {
    $params.Add("to=`'$to`'");
    
}

if (!($attachment.Equals("None"))) {
    if (Test-Path($attachment)) {
        $fullPath = (Get-Item $attachment).FullName;
        $params.Add("attachment=`'$fullPath`'"); 
        
    
    } else {
        echo "The path `"$file`" does not exists."
    }
}

$command = $commandBegin;

# TODO: if params list is empty don't place "" in the command
$command += "`""
foreach ($param in $params) {
        $command += $param + ","
}
$command += "`""


Invoke-Expression $command;