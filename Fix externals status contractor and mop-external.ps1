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
    $OUpath = "OU=Users-External,OU=$item,OU=RSE,OU=HSDG,DC=hsdg-ad,DC=int"
    $OUpath
    Get-ADUser -Filter * -SearchBase $OUpath | ForEach-Object {
    $new_employeeType= "contractor"
    $A12 = "mop-external"
    Set-ADUser -Identity $_ -Add @{extensionAttribute12 = $A12}
    Set-ADUser -Identity $_ -Replace @{employeeType=$new_employeeType}
    }
    }


