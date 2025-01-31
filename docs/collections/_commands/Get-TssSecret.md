---
category: secrets
external help file: Thycotic.SecretServer-help.xml
Module Name: Thycotic.SecretServer
online version: https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssSecret
schema: 2.0.0
title: Get-TssSecret
---

# Get-TssSecret

## SYNOPSIS
Get a secret from Secret Server

## SYNTAX

### secret (Default)
```
Get-TssSecret [-TssSession] <TssSession> -Id <Int32[]> [<CommonParameters>]
```

### restricted
```
Get-TssSecret [-TssSession] <TssSession> [-Id <Int32[]>] [-Comment <String>]
 [-DoublelockPassword <SecureString>] [-ForceCheckIn] [-IncludeInactive] [-TicketNumber <String>]
 [-TicketSystemId <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get a secret(s) from Secret Server

## EXAMPLES

### EXAMPLE 1
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Get-TssSecret -TssSession $session -Id 93
```

Returns secret associated with the Secret ID, 93

### EXAMPLE 2
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Get-TssSecret -TssSession $session -Id 1723 -Comment "Accessing application Y"
```

Returns secret associated with the Secret ID, 1723, providing required comment

### EXAMPLE 3
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
$secret = Get-TssSecret -TssSession $session -Id 46
$cred = $secret.GetCredential('domain','username','password')
```

Gets Secret ID 46 (Active Directory template).
Call GetCredential providing slug names for desired fields to get a PSCredential object

### EXAMPLE 4
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
$secret = Search-TssSecret -TssSession $session -FieldSlug server -FieldText 'sql1' | Get-TssSecret
$cred = $secret.GetCredential($null,'username','password')
$serverName = $secret.GetValue('server')
```

Search for the secret with server value of sql1 and pull the secret details.
Call GetCredential() method, only needing the username and password values for the PSCredential object.
Call GetValue() method to get the 'server' value.

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
Secret ID to retrieve

```yaml
Type: Int32[]
Parameter Sets: secret
Aliases: SecretId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: Int32[]
Parameter Sets: restricted
Aliases: SecretId

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -DoublelockPassword
Double lock password, provie as a secure string

```yaml
Type: SecureString
Parameter Sets: restricted
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceCheckIn
Check in the secret if it is checked out

```yaml
Type: SwitchParameter
Parameter Sets: restricted
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeInactive
Include secrets that are inactive/disabled

```yaml
Type: SwitchParameter
Parameter Sets: restricted
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketNumber
Associated ticket number (required for ticket integrations)

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

### -TicketSystemId
Associated ticket system ID (required for ticket integrations)

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TssSecret
## NOTES
Requires TssSession object returned by New-TssSession

## RELATED LINKS

[https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssSecret](https://thycotic-ps.github.io/thycotic.secretserver/commands/Get-TssSecret)

[https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/secrets/Get-Secret.ps1](https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/secrets/Get-Secret.ps1)

