<# 
Created by Rodrigo Lima (rodrlima)
Rodrigo.lima-external@alianca.com.br
#>

$Release = "0.03"
Add-Type -AssemblyName System.Windows.Forms
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize.Height          = 1400
$Form.ClientSize.Width           = 745
$Form.text                       = "Get user info"
$Form.TopMost                    = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Username"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(19,28)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$UserNameBox                     = New-Object system.Windows.Forms.TextBox
$UserNameBox.Text                = ""
$UserNameBox.multiline           = $false
$UserNameBox.width               = 118
$UserNameBox.height              = 20
$UserNameBox.location            = New-Object System.Drawing.Point(94,24)
$UserNameBox.Font                = 'Microsoft Sans Serif,10'

$GetButton                       = New-Object system.Windows.Forms.Button
$GetButton.text                  = "Get info"
$GetButton.width                 = 82
$GetButton.height                = 30
$GetButton.location              = New-Object System.Drawing.Point(232,17)
$GetButton.Font                  = 'Microsoft Sans Serif,10'

$CLRButton                       = New-Object system.Windows.Forms.Button
$CLRButton.text                  = "Clear"
$CLRButton.width                 = 60
$CLRButton.height                = 30
$CLRButton.location              = New-Object System.Drawing.Point(330,17)
$CLRButton.Font                  = 'Microsoft Sans Serif,10'
$CLRButton.ForeColor             = ""

$ResultBox                       = New-Object system.Windows.Forms.textbox
$ResultBox.multiline             = $true
$ResultBox.width                 = 1375
$ResultBox.height                = 655
$ResultBox.enabled               = $True
$ResultBox.Anchor                = 'top,right,bottom,left'
$ResultBox.location              = New-Object System.Drawing.Point(19,67)
$ResultBox.Font                  = 'Lucida Console,10'
$ResultBox.Text                  = ""
$ResultBox.Scrollbars            = "Both"

$Version                         = New-Object system.Windows.Forms.Label
$Version.text                    = $Release
$Version.AutoSize                = $true
$Version.width                   = 25
$Version.height                  = 10
$Version.location                = New-Object System.Drawing.Point(22,727)
$Version.Font                    = 'Microsoft Sans Serif,10'
$Version.Anchor                  = 'bottom'

$Form.controls.AddRange(@($Label1,$UserNameBox,$GetButton,$CLRButton,$ResultBox,$Version))

$UserNameBox.Add_KeyDown({ 
if ($_.KeyCode -eq "Enter") {
GetinfoFunction $UserNameBox.text }
})
$GetButton.Add_Click({ GetinfoFunction $UserNameBox.text })
$CLRButton.Add_Click({ ClearAll })

function ClearAll {
$UserNameBox.text = ""
$ResultBox.text = ""
$UserNameBox.Focus() }

function GetinfoFunction ($UserName) {
$Result = get-aduser $UserName `
    -properties DistinguishedName,name, enabled, mail, extensionAttribute1,extensionAttribute3,extensionAttribute14, PasswordLastSet, PasswordExpired,lastlogon,employeeType,ScriptPath |
    select-object name,mail, DistinguishedName, enabled,ScriptPath, extensionAttribute1,extensionAttribute3,extensionAttribute14, PasswordLastSet, PasswordExpired,@{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogon)}},employeeType |Format-list |out-string -Width 170
$Groups = Get-ADPrincipalGroupMembership $UserName
$ResultGroups = $Groups | 
    select-object name |
    Sort-Object -Property name |
    Format-Wide -AutoSize| Out-String -Width 170
    #Format-Wide -Column 3 -AutoSize| Out-String

$Filgroups = 
$Groups | 
    Where-Object {$_ -Like "*-FIL*"} | 
    Sort-Object -Property name | 
    Get-ADGroup -Properties Description | 
    Select-object Name,Description | 
    Format-Table -AutoSize | Out-String -Width 170

$SCRGroups = 
$Groups | 
    Where-Object {$_ -Like "*-SCR-*"} | 
    Sort-Object -Property name | 
    Get-ADGroup -Properties Description | 
    Select-object Name,Description | 
    Format-Table -AutoSize | Out-String -Width 170

$ResultBox.text = $Result
$ResultBox.text += "User Groups"
$ResultBox.text += $ResultGroups
$ResultBox.text += "Folder Groups"
$ResultBox.text += $Filgroups
$ResultBox.text += "SCR groups:"
$ResultBox.text += $SCRGroups

 }




[void]$Form.ShowDialog()