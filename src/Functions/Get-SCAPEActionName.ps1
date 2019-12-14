Function Get-SCAPEActionName {
    Param(
        [int]$MessageId
    )
    switch ($MessageId) {
        30006 { return "Created" }
        30007 { return "Modified" }
        30008 { return "Deleted" }
        30226 { return "Created" }
        30227 { return "Modified" }
        30228 { return "Deleted" }
        30016 { return "Modified" }
        30152 { return "Modified" }
        30001 { return "Modified" }
        30068 { return "Modified" }
        30004 { return "Modified" }
    }
}