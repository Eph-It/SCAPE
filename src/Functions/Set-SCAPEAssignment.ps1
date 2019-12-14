Function Set-SCAPEAssignment {
    Param(
        $Assignment
    )
    $Query = "Select * FROM SMS_ApplicationAssignment WHERE AssignmentID = '$($Assignment.AssignmentId)'"
    $WMIAssignment = Get-SCAPEWMIDeployment -query $Query
    if($null -ne $WMIAssignment) {
        $TenYears = ([DateTime]::UtcNow.AddYears(10)).Year
        $CurrentEnforcementDeadline = $WMIAssignment.EnforcementDeadline
        $CurrentStartTime = $WMIAssignment.StartTime
        $CurrentExpirationTime = $WMIAssignment.ExpirationTime
        if(-not [string]::IsNullOrEmpty($CurrentEnforcementDeadline)){
            $WMIAssignment.EnforcementDeadline = "$($TenYears)$($CurrentEnforcementDeadline.Substring(4, $CurrentEnforcementDeadline.Length - 4))"
        }
        if(-not [string]::IsNullOrEmpty($CurrentStartTime)){
            $WMIAssignment.StartTime = "$($TenYears)$($CurrentStartTime.Substring(4, $CurrentStartTime.Length - 4))"
        }
        if(-not [string]::IsNullOrEmpty($CurrentExpirationTime)){
            $WMIAssignment.ExpirationTime = "$($TenYears)$($CurrentExpirationTime.Substring(4, $CurrentExpirationTime.Length - 4))"
        }
        $WMIAssignment.Put()
    }
}