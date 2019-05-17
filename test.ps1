function design-drawcircle($locationX,$locationY,$sizeX,$sizeY,$color) {
    $brush1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::$color);
    $rect1 = New-Object System.Drawing.Rectangle($locationX,$locationY,$sizeX,$sizeY);
    $formGraphics = $objForm.CreateGraphics();
    $formGraphics.RenderingOrigin = New-Object System.Drawing.Size(10,10)
    $formGraphics.FillEllipse($brush1, $rect1);
# Define the paint handler
Write-Output $formGraphics.FillEllipse($brush1, $rect1);
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    # form parameters
    $formwidth = 960
    $formheight = 640
   
    $objForm = New-Object System.Windows.Forms.Form
    $objForm.Text = "title"
    $objForm.Size = New-Object System.Drawing.Size($formwidth,$formheight)
    $objForm.StartPosition = "CenterScreen"
   
    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter")
           {$exe=$objTextBox.Text;$objForm.Close()}})
    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
           {$objForm.Close()}})

    # testo: STEP1
    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(20,65)
    $objLabel.Size = New-Object System.Drawing.Size(20,24)
    #$objLabel.TextAlign = "MiddleCenter"
    $objLabel.Text = 1
    $objLabel.BackColor = "DarkBlue";
    $objLabel.ForeColor = "White";
    $objLabel.Font = New-Object System.Drawing.Font("arial",18,[System.Drawing.FontStyle]::Bold);
    $objForm.Controls.Add($objLabel)

# Define the paint handler
    $objForm.add_paint({
     design-drawcircle -locationX 5 -locationY 55 -sizeX 50 -sizeY 50 -color "DarkBlue"     
    })
$objForm.showdialog()