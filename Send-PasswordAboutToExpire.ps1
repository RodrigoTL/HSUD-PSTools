
$filterDate = [datetime]::Today.AddDays(+5)
$filterDate2 = [datetime]::Today.AddDays(+1)

$filterDate
$filterDate2
$UsersWithpasswordabouttoexpire = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False } –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed","mail","extensionAttribute14" -SearchBase "OU=RSE,OU=HSDG,DC=hsdg-ad,DC=int" |
Select-Object -Property "Displayname",SamAccountName,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}},"mail","extensionAttribute14" |
Where-Object {$_.ExpiryDate -le $filterDate -and $_.ExpiryDate -ge $filterDate2}

$UsersWithpasswordabouttoexpire|ft
$UsersWithpasswordabouttoexpire.Count

$report = $UsersWithpasswordabouttoexpire|Sort-Object -Property ExpiryDate |ft -AutoSize|Out-String

Send-MailMessage -To rodrigo.lima-external@alianca.com.br -from Servicedesk-sao@hamburgsud.com -Subject "$($UsersWithpasswordabouttoexpire.Count) Usuários com senha expirando" -Body $report -SmtpServer smtp-rse.hsdg-ad.int -Encoding UTF32

    foreach ($User in $UsersWithpasswordabouttoexpire) {

            $to = @()
            if($User.mail){
                $to +=$User.mail}
            if($User.extensionAttribute14){
                $to +=$User.extensionAttribute14}
            
            $data = $($User.ExpiryDate.ToLocalTime)
            $subject = "Your password is about to expire | Sua senha está prestes a expirar"
            $body = @"
<body style="font-family:Arial;">

Por favor,<br>
<br>
A senha do usuario $($User.SamAccountName) vai expirar $([System.Threading.Thread]::CurrentThread.CurrentCulture = "pt-BR"; $User.ExpiryDate.DateTime) (UTC-3) <br>
<br>
Fa&ccedil;a a troca de senha o mais breve poss&iacute;vel, para n&atilde;o ter problemas de acesso<br>
<br>
Na VPN ou no escrit&oacute;rio pressione Ctrl + Alt + Del e selecione trocar uma senha<br>
No Citrix na barra preta no topo da tela pressione o bot&atilde;o &ldquo;Ctrl + Alt + Del&rdquo; e selecione Change a password.<br>
________________________<br>
<br>
Please,<br>
<br>
User $($User.SamAccountName) password will expire at $([System.Threading.Thread]::CurrentThread.CurrentCulture = "en-US"; $User.ExpiryDate.DateTime) (UTC-3)<br>
<br>
Change your password as soon as possible, so you will have no trouble to access<br>
<br>
At the VPN or at the office press Ctrl + Alt + Del and select change a password<br>
In Citrix on the black bar at the top of the screen, press the &ldquo;Ctrl + Alt + Del&rdquo; button and select Change a password.
<p>&nbsp;</p>
<p>Kind Regards \ Atenciosamente,</p>
<p><strong>Service Desk - SAO</strong></br>
Information Technology &amp; Organization</br>
Hamburg S&uuml;d Brasil Ltda</br>
Alian&ccedil;a Navega&ccedil;&atilde;o e Log&iacute;stica Ltda</br>
___________________________________________________</br>
Rua Verbo Divino, 1547 04719-002 S&atilde;o Paulo, SP Brasil</br>
Phone: +55 11 3775-4000</br>
Email: <a href="mailto:servicedesk-sao@hamburgsud.com">servicedesk-sao@hamburgsud.com</a></p>
"@
            
            


#$body
if ($to){
Send-MailMessage -To $to -Bcc rodrigo.lima-external@alianca.com.br -from Servicedesk-sao@hamburgsud.com -Subject $subject -Body $body -BodyAsHtml -SmtpServer smtp-rse.hsdg-ad.int -Encoding UTF32
}
#Send-MailMessage -To rodrigo.lima-external@alianca.com.br -from Servicedesk-sao@alianca.com.br -Subject $subject -Body $body -BodyAsHtml -SmtpServer smtp-rse.hsdg-ad.int -Encoding UTF32
            
}

