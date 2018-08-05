param(
	$data
)

$Name=$data.Name

foreach($i in 1..10)
{
	Start-Sleep -Seconds 6
	Add-Content -Path "\\SRV01\C$\testDir\$Name.txt" -Value 'Test' 
}