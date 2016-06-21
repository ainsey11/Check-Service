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
$MailServer = ""
$MailSender = ""
$MailRecipient = ""
$MailPriority = ""
$MailSubject = ""
$Mailbody = "" 



Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

$Status = Invoke-Command -ComputerName $ADServers.name -ScriptBlock {Get-Service -Name "Solarwinds*"} -ErrorVariable $outputerror -ErrorAction SilentlyContinue

$Status  | ForEach-Object {
if ($_.Status -ne "Running"){
Write-Host "The Server" $_.PSComputerName "has an issue. Status is currently"$_.Status
Send-MailMessage -SmtpServer $MailServer -From $MailSender -To $MailRecipient -Priority $MailPriority -Subject $MailSubject -Body $MailBody
}

}
