# TODO add other options available by Thunderbird or Postbox
# The full list is available at http://kb.mozillazine.org/Command_line_arguments_(Thunderbird)
# DONE allow to get many attachments via pipe, eg. ls *.txt | send-mail.ps1
param(
    [string]$to='',
    [string]$attachment='',
    [string]$exec = 'C:\Program Files (x86)\Postbox\postbox.exe'
    )

$commandBegin = "& `"$exec`" -compose "
# ------ Read params from input -------------


$params = New-Object Collections.Generic.List[string]

# Assign TO parameter
if ($to) {
    $params.Add("to=`'$to`'");
}

# Assign ATTACHMENTS parameter
if ($attachment) {

    if (Test-Path($attachment)) {
        $fullPath = (Get-Item $attachment).FullName;
        $params.Add("attachment=`'$fullPath`'"); 
        
    } else {
        echo "The path `"$file`" does not exists."
    }
} else {
    # Try to assign ATTACHMENTS parameter from pipeline 
    $attachParam = "attachment=`'"
    foreach ($filename in $input) {
         $fullPath = $filename.FullName + ","
         echo $fullPath
         $attachParam += $fullPath
    }

    $attachParam += "`'"
    $params.Add($attachParam)
}

# ----- Build & run command -------------

$command = $commandBegin;

# TODO: if params list is empty don't place "" in the command
$command += "`""
foreach ($param in $params) {
        $command += $param + ","
}
$command += "`""


Invoke-Expression $command;