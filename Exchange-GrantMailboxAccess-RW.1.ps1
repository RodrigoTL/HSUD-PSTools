#The user that runs this sprit command needs to have Adm rights on exchange to work

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
     $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://saovw360.hsdg-ad.int/PowerShell -Authentication Kerberos
     Import-PSSession $session -CommandName Add-MailboxPermission,Get-MailboxPermission,Get-Mailbox,Add-ADPermission | Out-Null
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
               Get-Mailbox $MB | Get-MailboxPermission | Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false}| Select-Object user, accessrights |Format-Table
          }
     }
     
     end {
     $session | Remove-PSSession
     }
}
