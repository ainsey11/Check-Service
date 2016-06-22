<#    
  .SYNOPSIS   
    Checks to see if service is running, if not - restart it, mail me. If service non existant, mail me   
  .DESCRIPTION   
    Checks to see if service is running, if not - restart it, mail me. If service non existant, mail me. Uses an AD query to find computers 
  .NOTES 
  Author: Ainsey11 <https://ainsey11.com>                                      
  Date : 18/05/2016                           
#> 


#Importing Modules
Import-Module ActiveDirectory

# Setting up variables

$ADFilter = {(Operatingsystem -Like "Windows Server*") -And (Enabled -eq "True")}
$ADServers = Get-ADComputer -Filter $ADFilter -Properties *
$date = $date = Get-Date -Format HH-mm-dd-MMM-yyyy
$logfile = "C:\Scripting\Logs\Check-Service\$date"
$MailServer = "#"
$MailSender = "#"
$MailRecipient = "#"
$MailPriority = "High"
$MailSubject = "Solarwinds Service Failure"
$MailBody = "Solarwinds Service has stopped on one of the active servers on the timicogroup.local domain. <br>
                <br><br> 
                To find ones that have the service stopped, use a custom powershell loop I have premade for this case. Please see the attachment to this INC. <br>
                Rename to .PS1 then comment out from line 47 and below using # . Uncomment line 46 by removing the #<br>
                Copy the file to the desktop of a domain server, IE man01 <br>
                open powershell <br>
                type cd C:\users\<username>\Desktop  <br>
                run .\Check-Service.ps1 <br>
                Servers with the stopped status are the ones that require attention <br>
                RDP to those servers and start the Solarwinds Agent Service.<br><br>
                THIS IS IS NOT TO BE IGNORED!!. <br>
                <br>
                <br>
                If there are any issues with this notification, or there are bugs / errors please notify Internal IT.
               "

$MailAttatchment = "C:\Scripting\Check-Service\Check-Service.txt"

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

$Status = Invoke-Command -ComputerName $ADServers.name -ScriptBlock {Get-Service -Name "Solarwinds*"} -ErrorVariable $outputerror -ErrorAction SilentlyContinue
#$Status

$Status  | ForEach-Object {
if ($_.Status -ne "Running"){
#Write-Host "The Server" $_.PSComputerName "has an issue. Status is currently"$_.Status
Send-MailMessage -SmtpServer $MailServer -From $MailSender -To $MailRecipient -Priority $MailPriority -Subject $MailSubject -Body $Mailbody -Attachments $MailAttatchment -BodyAsHtml
}
}