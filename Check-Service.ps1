<#    
  .SYNOPSIS   
    Checks to see if service is running, if not - restart it, mail me. If service non existant, mail me   
  .DESCRIPTION   
    Checks to see if service is running, if not - restart it, mail me. If service non existant, mail me. Uses a foreachloop to find computers 
  .NOTES 
  Author: Ainsey11 <https://ainsey11.com>                                      
  Date : 18/05/2016                           
#> 

#Set up my variables
Import-Module "ActiveDirectory" 

# Other settings
$ServerFilter = {(Name -Like "THQ*") -And (Enabled -eq "True")}
$servicename = "SolarWindsAgent64"
$date = Get-Date -Format HH-mm-dd-MMM-yyyy
$logfile = C:\Scripting\Logs\Check-Service\$date.txt

# Mail server settings

$smtpserver = "#"
$smtpfrom = "#"
$smtpto = "#"
$smtpsubject = "Ainsey11 Service WatchGuard"
$smtppriority = "High"
$smtpbody = "The $servicename service has failed on $failedserver please investigate"

$servers = Get-ADComputer -Filter $ServerFilter -Properties * 
   Foreach ($server in $servers)
    {
   
   if (Get-Service $servicename)
   {
    Add-Content $logfile "$server has $servicename installed"
    $CheckRunning = "yes"
    }
    else 
    {
    Add-Content $logfile "$server has not got $servicename installed! Please install"
    Send-MailMessage -SmtpServer $smtpserver -From $smtpfrom -To $smtpto -Subject $smtpsubject -Priority $smtppriority -Body "$servicename does not exist on $server. Please Install to clear error"
    $checkrunning = "no"
    }
    
    if ($CheckRunning -eq "yes"){
        $Service = Get-Service $servicename
        if ($Service.Status -ne "Started"){
            Send-MailMessage -SmtpServer $smtpserver -From $smtpfrom -To $smtpto -Subject $smtpsubject -Priority $smtppriority -Body $smtpbody
            Add-Content $logfile "Service has stopped on $server. Please restart"
        }
    else {
    Add-Content $logfile "Service is running on $server, all is good"
    }
    }
    }
