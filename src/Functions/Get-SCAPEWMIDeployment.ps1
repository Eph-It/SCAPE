Function Get-SCAPEWMIDeployment{
    Param(
        [string]$query,
        [int]$Count = 0
    )
    $MaxCount = 15
    $Deployment = Get-WMIObject -Query $Query -Namespace "root\sms\site_$($Script:SCAPESettings.SiteCode)" -ComputerName $Script:SCAPESettings.WMIProviderServer
    if($null -eq $Deployment) {
        $count++
        if($Count -lt $MaxCount) {
            Start-Sleep 1
            Get-SCAPEWMIDeployment -query $query -Count $Count
        }
    }
    else {
        $Deployment.Get()
        $Deployment
    }
}