---
category: general
external help file: Thycotic.SecretServer-help.xml
Module Name: Thycotic.SecretServer
online version: https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssUserRoleAssigned
schema: 2.0.0
title: Get-TssUserRoleAssigned
---

# Get-TssUserRoleAssigned

## SYNOPSIS
Get roles assigned to User Id

## SYNTAX

```
Get-TssUserRoleAssigned [-TssSession] <TssSession> -UserId <Int32[]> [<CommonParameters>]
```

## DESCRIPTION
Get roles assigned to User Id

## EXAMPLES

### EXAMPLE 1
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Get-TssUserRoleAssigned -TssSession $session -UserId 254
```

Returns roles assigned to the User ID 254

## PARAMETERS

### -TssSession
TssSession object created by New-TssSession for auth

```yaml
Type: TssSession
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserId
Short description for parameter

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TssUserRoleSummary
## NOTES
Requires TssSession object returned by New-TssSession
Only supported on 10.9.32 or higher of Secret Server

## RELATED LINKS

[https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssUserRoleAssigned](https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssUserRoleAssigned)

[https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/users/Get-UserRoleAssigned.ps1](https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/users/Get-UserRoleAssigned.ps1)

