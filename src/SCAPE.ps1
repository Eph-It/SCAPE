param(
    [int]$MessageId,
    [string]$InsStr1,
    [string]$InsStr2,
    [string]$InsStr3,
    [string]$InsStr4,
    [string]$InsStr5
)

$Script:SCAPESettings = ConvertFrom-JSON ( Get-Content -Path "$PSScriptRoot\SCAPESettings.json" -Raw )

$Functions = Get-ChildItem -Path "$PSSCriptRoot\Functions" -Filter '*.ps1'
foreach($Function in $Functions) {
    . $Function.FullName
}

if(
    ("$($env:USERDOMAIN)\$($env:USERNAME)" -eq $InsStr1) -or
    ( $SCAPESettings.ExcludedUsers -contains $InsStr1 ) -or
    ( 'NT AUTHORITY\SYSTEM' -eq $InsStr1 ) ) {
    #Have to exclude the current user to avoid a bad loop
    exit
}

$Deployments = Get-SCAPEDeployment -MessageID $MessageId -InsString2 $InsStr2 -InsString3 $InsStr3 -InsString4 $InsStr4

foreach($deployment in $Deployments){
    $DeploymentInformation = ConvertTo-SCAPEPSObject -Deployment $deployment
    if($DeploymentInformation.StartTime -gt [DateTime]::UTCNow.AddYears(9)){
        exit
    }
    $DeploymentInformation.Creator = $InsStr1.Split('\')[1]
    $DeploymentInformation.CMAction = Get-SCAPEActionName -MessageId $MessageId
    $DeploymentInformation.CMObjectType = Get-SCAPEObjectName -MessageId $MessageId
    if($null -ne $deployment.OfferId) {
        $DeploymentInformation = Set-SCAPEAdvertisement -Advertisement $DeploymentInformation
    }
    elseif ($null -ne $deployment.AssignmentID) {
        $DeploymentInformation = Set-SCAPEAssignment -Assignment $DeploymentInformation
    }
    $null = Invoke-RestMethod -Uri $Script:SCAPESettings."StartWebHook" -Method 'Post' -Body ($DeploymentInformation | ConvertTo-JSON) -ContentType 'application/json'
}

