# Import the Active Directory module
Import-Module ActiveDirectory

# Create an empty array to hold the computers
$computers = @()

# Get a list of prod.local computers in specific OUs
$searchBases = "OU=example,OU=example,DC=prod,DC=local","OU=example,OU=example,DC=prod,DC=local"

foreach ($searchBase in $searchBases) {
    $computers += Get-ADComputer -Filter * -SearchBase $searchBase
}

# Create an empty array to hold the data
$data = @()

# Iterate through the list of computers
foreach ($computer in $computers) {
    # Get the OU of the computer
    $ou = (Get-ADObject -Identity $computer.DistinguishedName -Properties CanonicalName).CanonicalName

    # Get the parent path
    $ouParent = Split-Path -Path $ou -Parent

    # Get the second-to-last element of the path
    $ouName = Split-Path -Path $ouParent -Leaf

    # Create a new object with the computer name and the OU
    $obj = [PSCustomObject]@{
        'Computer' = $computer.Name
        'Group Name' = $ouName
    }

    # Add the object to the data array
    $data += $obj
}

# Export the data to a CSV file
$data | Export-Csv -Path "C:\temp\rdcbuild.csv" -NoTypeInformation
