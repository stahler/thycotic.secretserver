class TssSecretSummary {
    [boolean]
    $Active

    [boolean]
    $AutoChangeEnabled

    [boolean]
    $CheckedOut

    [boolean]
    $CheckOutEnabled

    [datetime]
    $CreateDate

    [int]
    $DaysUntilExpiration

    [boolean]
    $DoubleLockEnabled

    [TssSecretSummaryExtendedField[]]
    $ExtendedFields

    [int]
    $FolderId

    [boolean]
    $HidePassword

    [int]
    $Id

    [boolean]
    $InheritsPermissions

    [boolean]
    $IsOutOfSync

    [string]
    $OutOfSyncReason

    [boolean]
    $IsRestricted

    [datetime]
    $LastAccessed

    [ValidateSet('Failed','Success','Pending','Disabled','UnableToConnect','UnknownError','IncompatibleHost','AccountLockedOut','DnsMismatch','UnableToValidateServerPublicKey','Processing','ArgumentError','AccessDenied')]
    [string]
    $LastHeartbeatStatus

    [datetime]
    $LastPasswordChangeAttempt

    [string]
    $Name

    [boolean]
    $RequiresApproval

    [boolean]
    $RequiresComment

    [int]
    $SecretTemplateId

    [string]
    $SecretTemplateName

    [int]
    $SiteId

    hidden
    [string[]]
    $ResponseCodes
}