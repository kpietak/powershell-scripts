param(
    [string]$Keyword = '',
    [string]$Editor = "${Env:ProgramFiles}\Sublime Text 2\sublime_text.exe"
    )


function isNumeric($x) {
    $x2 = 0
    return [System.Int32]::TryParse($x, [ref]$x2)
}

if (0 -eq $Keyword.Length) {
    "Please enter search keyword."
    "Usage: find-and-open keyword"
    exit
}

# TODO display info about number of results and ask if you want to display all or specific numbers...

$files = Get-ChildItem -Recurse -File "$Keyword" 
$resultsCnt = ($files | Measure-Object).Count

if ($resultsCnt -eq 0) {
    "Nothing found for `"$Keyword`""
    exit
} elseif ($resultsCnt -eq 1) {
    $cmd = " & `'$Editor`' $files"
    Invoke-Expression $cmd
} elseif ($resultsCnt -gt 1) {
    
    $FilesMap = @{}

    $i = 1
    foreach ($file in $files) {
        $FilesMap.Add($i++, $file)
        
    }
    
    # display all files
    "[A] All files..."
    
    foreach ($entry in $FilesMap.GetEnumerator() | Sort-Object Name ) {
        
        "[{0:D3}] {1}" -f $entry.Key, $entry.Value.FullName
        
        if ($entry.Key -gt 19) {  # TODO extract constant
            "... and {0:D3} more files." -f ($resultsCnt - 20)
            break
        }   
    }

    # get user's choice
    do {
        $input = Read-Host "Enter number of file to open, press 'A' if you want to open all files or 'q' to cancel operation"
    
        if ($input -eq 'A') {
            #open all files
            "Open all files"
        } elseif ($input -eq 'q') {
            break
        } elseif (isNumeric($input)) {
            [int]$i = $input
            "File no. {0:D} has been chosen" -f $i
        
            # display chosen files or cancel
            $cmd = "& `"{0}`" {1}" -f $Editor, $FilesMap.Get_Item($i).FullName
            echo $cmd
            Invoke-Expression $cmd
            break

        }

    } until ($input -eq 'q')

}

# $command = "gci -recurse `"$Keyword`" | % { & `"$Editor`" `$_.FullName } "

# $command.ToString()
# Invoke-Expression $command