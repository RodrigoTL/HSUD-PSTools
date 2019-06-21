#The user that runs this script command needs to have Adm rights on exchange to work

function Add-AccessToMailbox {
     [CmdletBinding()]
     param (
          [parameter(Mandatory=$true)]
          [String[]]
          $Users,
      
          [parameter(Mandatory=$true)]
          [String[]]
          $MailboxList
     )
     
     begin {
     #testing user list
          $Controlval = 0
          foreach ($item in $Users) {
               try {
                    get-aduser -identity $item > $null
               }
               catch {
                    write-host "The user $item is invalid" -ForegroundColor Red
                    $Controlval=1
               } 
          }
          if ($Controlval -eq 1) {
               Exit
          }
     #stating session on exchange server

     $session_paran = @{'ConfigurationName' = "Microsoft.Exchange";
                         'ConnectionUri' = 'http://saovw360.hsdg-ad.int/PowerShell'; #you can change to your exchange server here
                         'Authentication' = 'Kerberos'}

     $session = New-PSSession @session_paran
     Import-PSSession $session -CommandName Add-MailboxPermission,Get-MailboxPermission,Get-Mailbox,Add-ADPermission -AllowClobber | Out-Null
}
     process {
          #This funcition is where the permitions are given
          foreach ($MB in $MailboxList) {
               foreach ($User in $Users) {
                    Add-MailboxPermission -Identity $MB -user $User -AccessRights FullAccess -AutoMapping $false -InheritanceType All|
                    Add-ADPermission -ExtendedRights Send-As -User $User |Out-Null
                    Write-Host "Access Granted in $MB for $User"
               }
          }
          #This function will give a list of users of each changed mailbox
          foreach ($MB in $MailboxList) {
               $Message = "New list of users of $MB"
               Write-Host $('-'*($Message.Length))
               Write-Host $Message
               Write-Host $('-'*($Message.Length))
               Get-Mailbox $MB | Get-MailboxPermission | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false}| Select-Object user, accessrights |Format-Table -AutoSize
          }
     }
     
     end {
     $session | Remove-PSSession
     }
}
function Get-AccessToMailbox {
     [CmdletBinding()]
     param (
          [parameter(Mandatory=$true)]
          [String[]]
          $MailboxList
     )
     
     begin {

     $session_paran = @{'ConfigurationName' = "Microsoft.Exchange";
                         'ConnectionUri' = 'http://saovw360.hsdg-ad.int/PowerShell'; #you can change to your exchange server here
                         'Authentication' = 'Kerberos'}

     $session = New-PSSession @session_paran
     Import-PSSession $session -CommandName Add-MailboxPermission,Get-MailboxPermission,Get-Mailbox,Add-ADPermission -AllowClobber | Out-Null
}
     process {
          #This function will give a list of users of each Mailbox
          foreach ($MB in $MailboxList) {
               $Message = "list of users of $MB"
               Write-Host $('-'*($Message.Length))
               Write-Host $Message
               Write-Host $('-'*($Message.Length))
               Get-Mailbox $MB | Get-MailboxPermission | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false}| Select-Object user, accessrights |Format-Table -AutoSize
          }
     }
     
     end {
     $session | Remove-PSSession
     }
}
function Remove-AccessToMailbox {
     [CmdletBinding()]
     param (
          [parameter(Mandatory=$true)]
          [String[]]
          $Users,
      
          [parameter(Mandatory=$true)]
          [String[]]
          $MailboxList
     )
     
     begin {
     #testing user list
          $Controlval = 0
          foreach ($item in $Users) {
               try {
                    get-aduser -identity $item > $null
               }
               catch {
                    write-host "The user $item is invalid" -ForegroundColor Red
                    $Controlval=1
               } 
          }
          if ($Controlval -eq 1) {
               Exit
          }
     #stating session on exchange server

     $session_paran = @{'ConfigurationName' = "Microsoft.Exchange";
                         'ConnectionUri' = 'http://saovw360.hsdg-ad.int/PowerShell'; #you can change to your exchange server here
                         'Authentication' = 'Kerberos'}

     $session = New-PSSession @session_paran
     Import-PSSession $session -CommandName Remove-MailboxPermission,Get-MailboxPermission,Get-Mailbox,Remove-ADPermission -AllowClobber | Out-Null
}
     process {
          #This funcition is where the permitions are Removed
          foreach ($MB in $MailboxList) {
               foreach ($User in $Users) {
                    Remove-MailboxPermission -Identity $MB -user $User -AccessRights FullAccess -InheritanceType All|
                    Remove-ADPermission -ExtendedRights Send-As -User $User |Out-Null
                    Write-Host "Access REMOVED in $MB for $User"
               }
          }
          #This function will give a list of users of each changed mailbox
          foreach ($MB in $MailboxList) {
               $Message = "New list of users of $MB"
               Write-Host $('-'*($Message.Length))
               Write-Host $Message
               Write-Host $('-'*($Message.Length))
               Get-Mailbox $MB | Get-MailboxPermission | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false}| Select-Object user, accessrights |Format-Table -AutoSize
          }
     }
     
     end {
     $session | Remove-PSSession
     }
}
