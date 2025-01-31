---
category: secrets
external help file: Thycotic.SecretServer-help.xml
Module Name: Thycotic.SecretServer
online version: https://thycotic-ps.github.io/thycotic.secretserver/commands/Disable-TssSecretEmail
schema: 2.0.0
title: Enable-TssSecretEmail
---

# Enable-TssSecretEmail

## SYNOPSIS
Enables the email setting for a Secret

## SYNTAX

### all (Default)
```
Enable-TssSecretEmail [-TssSession] <TssSession> -Id <Int32[]> [-WhenChanged] [-WhenViewed]
 [-WhenHeartbeatFails] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### restricted
```
Enable-TssSecretEmail [-TssSession] <TssSession> -Id <Int32[]> [-WhenChanged] [-WhenViewed]
 [-WhenHeartbeatFails] [-Comment <String>] [-TicketNumber <Int32>] [-TicketSystemId <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Enables the email setting for a Secret

## EXAMPLES

### EXAMPLE 1
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Enable-TssSecretEmail -TssSession $session -Id 28 -WhenViewed
```

Enable Secret 28's Email When Viewed setting

### EXAMPLE 2
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Enable-TssSecretEmail -TssSession $session -Id 42,43,45 -WhenViewed
```

Enable Email When Viewed setting on Secret IDs 42, 43, and 45

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

### -WhenChanged
Email when changed to true

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhenViewed
Email when viewed to true

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhenHeartbeatFails
Email when HB fails to true

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
Comment to provide for restricted secret (Require Comment is enabled)

```yaml
Type: String
Parameter Sets: restricted
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketNumber
Associated Ticket Number

```yaml
Type: Int32
Parameter Sets: restricted
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketSystemId
Associated Ticket System ID

```yaml
Type: Int32
Parameter Sets: restricted
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Requires TssSession object returned by New-TssSession

## RELATED LINKS

[https://thycotic-ps.github.io/thycotic.secretserver/commands/Disable-TssSecretEmail](https://thycotic-ps.github.io/thycotic.secretserver/commands/Disable-TssSecretEmail)

[https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/secrets/Enable-SecretEmail.ps1](https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/secrets/Enable-SecretEmail.ps1)

