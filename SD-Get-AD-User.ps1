Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = '400,600'
$Form.text = "Get AD-User"
$Form.TopMost = $false

$Button1 = New-Object system.Windows.Forms.Button
$Button1.text = "Search"
$Button1.width = 60
$Button1.height = 30
$Button1.Anchor = 'right,bottom'
$Button1.location = New-Object System.Drawing.Point(313, 68)
$Button1.Font = 'Microsoft Sans Serif,10'

$Label1 = New-Object system.Windows.Forms.Label
$Label1.text = "Please enter Ad user name"
$Label1.AutoSize = $true
$Label1.width = 25
$Label1.height = 10
$Label1.location = New-Object System.Drawing.Point(35, 29)
$Label1.Font = 'Microsoft Sans Serif,10'

$TextBox1 = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline = $false
$TextBox1.width = 257
$TextBox1.Text = "User name"
$TextBox1.height = 20
$TextBox1.location = New-Object System.Drawing.Point(35, 68)
$TextBox1.Font = 'Microsoft Sans Serif,10'

$Label2 = New-Object System.Windows.Forms.Label
$Label2.text = "Display name"
$Label2.AutoSize = $true
$Label2.width = 25
$Label2.height = 10
$Label2.location = New-Object System.Drawing.Point(35, 120)
$Label2.Font = 'Microsoft Sans Serif,10'

$TextBox2 = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline = $true
$TextBox2.width = 307
$TextBox2.height = 20
$TextBox2.location = New-Object System.Drawing.Point(35, 142)
$TextBox2.Font = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($Button1, $Label1, $TextBox1, $TextBox2, $Label2))


$Button1.Add_Click(
    {    
        $TextBox2.Clear()
        $User = Get-ADuser -Identity $TextBox1.Text.trim() -Properties DistinguishedName,name, enabled, mail, extensionAttribute14, PasswordLastSet, PasswordExpired
        
        #populate Display name
        $TextBox2.AppendText($User.name) 

    }
)


[void]$Form.ShowDialog()
