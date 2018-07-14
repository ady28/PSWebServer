$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()

while($true)
{
    $Context = $listener.GetContext()
    $StreamReader = New-Object System.IO.StreamReader $context.request.InputStream
    $StreamData = $StreamReader.ReadToEnd()
    $JSON = $StreamData | ConvertFrom-Json
    $response = $context.Response
    $response.ContentType = 'application/json'
    $data=Get-Process | select -First 2 | ConvertTo-Json
    [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($data)
    $response.ContentLength64 = $buffer.length
    $output = $response.OutputStream
    $output.Write($buffer, 0, $buffer.length)
    $output.Close()
    $scrBlock={
    param(
        $Cont
    )
    
    foreach($n in 1..10)
    {
        Start-Sleep -Seconds 10
        Add-Content -Value "$($Cont.Text)" -Path "C:\test\$($Cont.Text).txt"
    }
    "Finished $($JSON.Text)"

    
    }

    Start-Job -ScriptBlock $scrBlock -ArgumentList $JSON


}