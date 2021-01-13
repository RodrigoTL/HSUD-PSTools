function Send-emailInstructions {
    param (
        [parameter(Mandatory=$true)]
        [String[]]
        $Users,
    
        [parameter(Mandatory=$true)]
        [String[]]
        $MailboxList
   )

   Process {
    foreach ($MB in $MailboxList) {
        foreach ($User in $Users) {
            $destino = (get-aduser -Identity $User -Properties mail).Mail 
            $MB = $MB + "@alianca.com.br"
            $subject = "Acesso a caixa $MB"
            $body = "<p>Ol&aacute; (get-aduser -Identity $User -Properties mail).name ,</p><p>Conforme foi requisitado, o acesso &agrave; caixa $MB foi concedido &agrave; voc&ecirc;.</p><p>Desta forma, segue o procedimento para abrir as caixas no outlook.</p><p>1&deg; - No <strong>Outlook</strong>, clicar em <strong><em>Arquivo -&gt; Adicionar Conta.</em></strong></p><p><strong><em><img src="https://i.ibb.co/PMJ1V08/7-T00-UL60-R2.png" alt="" width="491" height="266" /></em></strong></p><p>2&deg; - Preencher o campo<strong><em> Endere&ccedil;o de E-mail </em></strong>com a caixa desejada ($MB) e clique em <strong>Avan&ccedil;ar.</strong></p><p><strong><img src="https://i.ibb.co/rFS2Z3s/SW0-USQDI1-W.png" alt="" width="465" height="318" /></strong></p><p>3&deg; - Clique <em>em<strong> Concluir e reinicie o Outlook.</strong></em></p><p><em><strong><img src="https://i.ibb.co/zbwsnjh/71-PXGCAYAN.png" alt="" width="461" height="316" /></strong></em></p><p><em><strong><br /><img src="https://i.ibb.co/wccr4CH/0-RVXEHOR52.png" alt="" width="461" height="169" /><br /></strong></em></p><p>Ap&oacute;s reiniciar o outlook a caixa estar&aacute; dispon&iacute;vel no outlook.</p><p>&nbsp;</p><p>&nbsp;</p><p>Kind Regards \ Atenciosamente,</p><p>&nbsp;</p><p><strong>Service Desk - SAO</strong></p><p>Information Technology &amp; Organization</p><p>Hamburg S&uuml;d Brasil Ltda</p><p>Alian&ccedil;a Navega&ccedil;&atilde;o e Log&iacute;stica Ltda</p><p>___________________________________________________</p><p>Rua Verbo Divino, 1547 04719-002 S&atilde;o Paulo, SP Brasil</p><p>Phone: +55 11 3775-4000</p><p>Email: <a href="mailto:servicedesk-sao@hamburgsud.com">servicedesk-sao@hamburgsud.com</a></p>"
            Send-MailMessage -To $destino -from Servicedesk-sao@alianca.com.br ´
            -Subject $subject -Body $body ´
            -SmtpServer smtp-rse.hsdg-ad.int -BodyAsHtml
        }
   }
   }
    
}