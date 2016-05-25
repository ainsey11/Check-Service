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


# Other settings
$ServerFilter = {(Name -Like "THQ*") -And (Enabled -eq "True")}
$servicename = 
$date = Get-Date -Format HH-mm-dd-MMM-yyyy
$logfile = C:\Scripting\Logs\Check-Service\$date.txt

# Mail server settings

$smtpserver = "mail.acme.com"
$smtpfrom = "ainsey11@acme.com"
$smtpto = "ainsey11@acme.com"
$smtpsubject = "Ainsey11 Service WatchGuard"
$smtppriority = "High"
$smtpbody = "The $servicename service has failed on $failedserver please investigate"

$servers = Get-ADComputer -Filter $ServerFilter -Properties * 
    (foreach $server in $servers)
    {
   
   if (Get-Service "SolarWindsAgent64")
   {
    Add-Content $logfile "$server has $servicename installed"
    }
    else 
    {
    Add-Content $logfile "$server has not got $servicename installed! Please install"
    Send-MailMessage -SmtpServer $smtpserver -From $smtpfrom -To $smtpto -Subject $smtpsubject -Priority $smtppriority -Body "$servicename does not exist on $server. Please Install to clear error"
    }
    
    }



<#
sudo code - this'll be the end goal
    Get list of machines via ad
      for each, connect
      check if service is installed
        if not - mail me
        if so - cont
      is service running
           yes - end
           no - mail me
      end
#>
