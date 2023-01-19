# Import the computers from the CSV file
$computers = Import-Csv -Path "C:\temp\rdcbuild.csv"

# Create the RDCMan file using XmlDocument
$xml = New-Object System.Xml.XmlDocument

# Create the root node of the RDCMan file
$root = $xml.CreateElement("RDCMan")
$xml.AppendChild($root)
$root.SetAttribute("programVersion", "2.90")
$root.SetAttribute("schemaVersion", "3")

# Create the file node
$fileNode = $xml.CreateElement("file")
$root.AppendChild($fileNode)

# Create a dictionary to store the group elements
$groups = @{}

# Iterate through the CSV file and create the group and server elements
foreach($computer in $computers)
{
    # Get the group name
    $groupName = $computer.'Group Name'
    
    # Check if the group already exists in the dictionary
    if ($groups.ContainsKey($groupName))
    {
        # Use the existing group element
        $groupNode = $groups[$groupName]
    }
    else
    {
        # Create the group element
        $groupNode = $xml.CreateElement("group")
        $fileNode.AppendChild($groupNode)

        # Set the properties of the group element
        $propertiesNode = $xml.CreateElement("properties")
        $groupNode.AppendChild($propertiesNode)
        $nameNode = $xml.CreateElement("name")
        $propertiesNode.AppendChild($nameNode)
        $nameNode.InnerText = $groupName

        # Add the group to the dictionary
        $groups.Add($groupName, $groupNode)
    }
    
    # Create the server element
    $serverNode = $xml.CreateElement("server")
    $groupNode.AppendChild($serverNode)

    # Set the properties of the server element
    $serverPropertiesNode = $xml.CreateElement("properties")
    $serverNode.AppendChild($serverPropertiesNode)
    $serverNameNode = $xml.CreateElement("name")
    $serverPropertiesNode.AppendChild($serverNameNode)
    $serverNameNode.InnerText = $computer.Computer
}

# Save the RDCMan file
$xml.Save("C:\temp\rdcman.rdg")
