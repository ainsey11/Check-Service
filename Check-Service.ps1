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

# Mail server settings

$smtpserver 
$smtpfrom
$smtpto
$smtpsubject
$smtppriority
$smtpbody

# Other settings
$ServerFilter
$servicename


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

