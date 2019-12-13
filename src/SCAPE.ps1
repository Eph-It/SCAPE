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
    ($SCAPESettings.ExcludedUsers -contains "$($env:USERDOMAIN)\$($env:USERNAME)") -or
    ( $SCAPESettings.ExcludedUsers -contains $InsStr1 )) {
    #Have to exclude the current user to avoid a bad loop
    exit
}

$Collections = Invoke-SCAPESQLQuery -QUery 'Select * from v_Collections'
