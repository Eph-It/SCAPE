Function Invoke-SCAPESQLQuery {
    Param(
        [string]$Query
    )
    $SQLConnectionString = "Server=$($Script:SCAPESettings.SQLServer);Database=$($Script:SCAPESettings.DatabaseName);Integrated Security=True"
    $SQLConnection = New-Object System.Data.SqlClient.SQLConnection($SQLConnectionString)
    $SqlCommand = new-object system.data.sqlclient.sqlcommand($Query,$SQLConnection)
    $SQLConnection.Open()
    
    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $SqlCommand
    $dataset = New-Object System.Data.DataSet
    [void]$adapter.Fill($dataSet)
    $SQLConnection.Close()
    $dataSet.Tables
}