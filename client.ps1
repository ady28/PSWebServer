$a=@'
{
    "Text" : "test4"
}
'@

$res=Invoke-RestMethod -uri "http://localhost:8080/" -Method Post -ContentType 'application/json' -Body $a