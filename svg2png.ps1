param(
    [string]$path = '.',
    [string]$exec = 'C:\Program Files (x86)\Inkscape\inkscape.exe'
)

foreach ($filename in Get-ChildItem $path) {
    if ($filename.toString().EndsWith('.svg')) {
        
        $targetName = $filename.BaseName + ".png";

        $command = "& `"$exec`" -z -e `"$targetName`" -w 64 `"$filename`""; 
        Invoke-Expression $command;
        
    }
}


