Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = '400,600'
$Form.text = "Get AD-Group Members"
$Form.TopMost = $false

$Button1 = New-Object system.Windows.Forms.Button
$Button1.text = "Search"
$Button1.width = 60
$Button1.height = 30
$Button1.Anchor = 'right,bottom'
$Button1.location = New-Object System.Drawing.Point(313, 68)
$Button1.Font = 'Microsoft Sans Serif,10'

$Label1 = New-Object system.Windows.Forms.Label
$Label1.text = "Please enter pre2000 AD-Group name"
$Label1.AutoSize = $true
$Label1.width = 25
$Label1.height = 10
$Label1.location = New-Object System.Drawing.Point(35, 29)
$Label1.Font = 'Microsoft Sans Serif,10'

$TextBox1 = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline = $false
$TextBox1.width = 257
$TextBox1.height = 20
$TextBox1.location = New-Object System.Drawing.Point(36, 68)
$TextBox1.Font = 'Microsoft Sans Serif,10'

$TextBox2 = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline = $true
$TextBox2.width = 307
$TextBox2.height = 408
$TextBox2.location = New-Object System.Drawing.Point(38, 142)
$TextBox2.Font = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($Button1, $Label1, $TextBox1, $TextBox2))


$Button1.Add_Click(
    {    
        $TextBox2.Clear()
        $UserList = Get-ADGroupMember -Identity $TextBox1.Text.trim() -Recursive
        foreach ($user in $UserList) {
            $UserFromAD = Get-ADUser -Identity $user
            $TextBox2.AppendText($UserFromAD.name + "`r`n")
        }
     

    }
)


[void]$Form.ShowDialog()
