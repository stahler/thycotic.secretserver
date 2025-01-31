---
category: general
external help file: Thycotic.SecretServer-help.xml
Module Name: Thycotic.SecretServer
online version: https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssUserAudit
schema: 2.0.0
title: Get-TssUserAudit
---

# Get-TssUserAudit

## SYNOPSIS
Get audit for a user

## SYNTAX

```
Get-TssUserAudit [-TssSession] <TssSession> -UserId <Int32[]> [<CommonParameters>]
```

## DESCRIPTION
Get audit for a Secret Server User

## EXAMPLES

### EXAMPLE 1
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Get-TssUserAudit -TssSession $session -UserId 2
```

Get all of the audits for UserId 2

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

### TssUserAuditSummary
## NOTES
Requires TssSession object returned by New-TssSession

## RELATED LINKS

[https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssUserAudit](https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssUserAudit)

[https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/users/Get-UserAudit.ps1](https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/users/Get-UserAudit.ps1)

