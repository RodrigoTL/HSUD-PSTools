$region= "RSE"
$BUS =   "ASU",
         "BUE",
         "FOR",
         "ITJ",
         "JUN",
         "MAO",
         "MDZ",
         "PNZ",
         "POA",
         "REC",
         "RIG",
         "RIO",
         "SAO",
         "SBC",
         "SSA",
         "SSZ"

foreach ($item in $BUS)
    {
    $OUpath = "OU=Users,OU=$item,OU=$region,OU=HSDG,DC=hsdg-ad,DC=int"
    $OUpath
    Get-ADUser -Filter * -SearchBase $OUpath | ForEach-Object {
    $new_employeeType= "employee"
    
    Set-ADUser -Identity $_ -Replace @{employeeType=$new_employeeType}
    
    }
    }


