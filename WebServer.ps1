#Set up the listener to work only from the local host on port 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()

#Wait for client requests
while($true)
{
    $Context = $listener.GetContext()

    #Get data from the current request even if it is NULL (this will be treated route by route)
    $StreamReader = New-Object System.IO.StreamReader $context.request.InputStream
    $StreamData = $StreamReader.ReadToEnd()

    #Get the RAW URL, Method and the QueryStrings
    $RawUrl=$context.Request.RawUrl.Replace('/','')
    $QueryStrings=$context.Request.QueryString
    $HTTPMethod=$context.Request.HttpMethod

    #Use switch/case to execute route function
    switch($RawUrl)
    {
	TestTask
	{
	    $response = $context.Response
	    $response.Close()
	    Start-Job -FilePath C:\WebApi\TestTask.ps1
	}
	CreateRemoteFiles
	{
	    $response = $context.Response
	    $response.Close()
	    $JSONData = $StreamData | ConvertFrom-Json
	    Start-Job -ScriptBlock{C:\WebApi\CreateRemoteFiles.ps1 -data $args[0]} -ArgumentList $JSONData
	}
	#If no route is matching just Send the status of the WebApi
        default
        {
            $response = $context.Response
	    $response.ContentType = 'application/json'
	    $ResponseData=@{WebApiStatus='OK'} | ConvertTo-Json
	    [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($ResponseData)
            $response.ContentLength64 = $buffer.length
            $output = $response.OutputStream
    	    $output.Write($buffer, 0, $buffer.length)
    	    $output.Close()
        }
    }


    <#$JSON = $StreamData | ConvertFrom-Json
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

    Start-Job -ScriptBlock $scrBlock -ArgumentList $JSON#>


}