---
category: secrets
external help file: Thycotic.SecretServer-help.xml
Module Name: Thycotic.SecretServer
online version: https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssSecretHeartbeatStatus
schema: 2.0.0
title: Get-TssSecretHeartbeatStatus
---

# Get-TssSecretHeartbeatStatus

## SYNOPSIS
Get a Secret's Heartbeat status

## SYNTAX

```
Get-TssSecretHeartbeatStatus [-TssSession] <TssSession> -Id <Int32[]> [<CommonParameters>]
```

## DESCRIPTION
Get a Secret's Heartbeat status

## EXAMPLES

### EXAMPLE 1
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Get-TssSecretHeartbeatStatus -TssSession $session -Id 42
```

Returns heartbeat status of Secret 42

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

### -Id
Secret Id

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: SecretId

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

### TssSecretHeartbeatStatus
## NOTES
Requires TssSession object returned by New-TssSession

## RELATED LINKS

[https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssSecretHeartbeatStatus](https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssSecretHeartbeatStatus)

[https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/secrets/Get-SecretHeartbeatStatus.ps1](https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/secrets/Get-SecretHeartbeatStatus.ps1)

