Function Get-SCAPEDeployment {
    Param(
        [int]$MessageID,
        [string]$InsString2,
        [string]$InsString3,
        [string]$InsString4
    )
    $Deployments = @()
    $ObjectName = Get-SCAPEObjectName -MessageId $MessageID
    if([string]::IsNullOrEmpty($ObjectName)) { return }
    $QueryFiles = Get-ChildItem "$PSScriptRoot\SQL" -Filter "$($ObjectName)*.sql"
    $QueryParams = @{
        '@Id' = $InsString2
    }
    if($MessageID -eq 30004) { $QueryParams['@Id'] = $InsString3 }
    foreach($QueryFile in $QueryFiles){
        $SqlQuery = Get-Content $QueryFile.FullName -Raw
        Invoke-SCAPESQLQuery -Query $SqlQuery -QueryParams $QueryParams
    }
}