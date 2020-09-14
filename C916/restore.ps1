# Author: Stephen Henderson, Student ID: ###########
try
{   #Later on InvokeSql Command will change the path so lets save it
    Push-Location
    # Check if the OU exists
    if (Get-AdOrganizationalUnit -Filter "Name -eq 'finance'") {
      Write-Host "WARN: finance OU already exists"
    } else {
      New-AdOrganizationalUnit -Name "finance"
    }
	$ADUsers = Import-csv .\financePersonnel.csv
	foreach ($User in $ADUsers)
	{
	    # Some comment goes here
	$FirstName = $User.First_Name
        $LastName = $User.Last_Name
        $PostalCode = $User.PostalCode
        $MobilePhone = $User.MobilePhone
        $OfficePhone = $User.OfficePhone
    
        New-ADUser `
        -Name "$FirstName $Lastname" `
        -Surname "$LastName" `
        -GivenName "$FirstName" `
	-DisplayName "$Firstname $Lastname" `
	-OfficePhone $OfficePhone `
	-MobilePhone $MobilePhone `
        -Path "OU=finance,dc=ucertify,dc=com" 
	}
    #Assign Variables to SQL Server, Database Name and Table Name
    $SQL_Server = ".\UCERTIFY3"
    
    #Create The Database
    Invoke-Sqlcmd -ServerInstance $SQL_Server -Query 'CREATE DATABASE ClientDB'
    
    #Create the Table
    Invoke-Sqlcmd -ServerInstance $SQL_Server -Database 'ClientDB' -Query "CREATE TABLE Client_A_Contacts
    (
    [first_name] VARCHAR(40) not null,
    [last_name] VARCHAR(40) not null,
    [city] VARCHAR(40) not null,
    [county] VARCHAR(40) not null,
    [zip] int not null,
    [officePhone] VARCHAR(40) not null,
    [mobilePhone] VARCHAR(40) not null
    )
    "
    
    #Switch back to our saved directory
    Pop-Location
    
    #Pipe data from CSV into SQL Command For Loop
    Import-Csv .\NewClientData.csv | ForEach-Object { Invoke-Sqlcmd `
    -Database 'ClientDB' -ServerInstance $SQL_Server `
    -Query "insert into Client_A_Contacts VALUES ('$($_.first_name)','$($_.last_name)','$($_.city)','$($_.county)','$($_.zip)','$($_.officePhone)','$($_.mobilePhone)')"
    }
}
catch [System.OutOfMemoryException]
{
Break
}
