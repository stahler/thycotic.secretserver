---
category: general
external help file: Thycotic.SecretServer-help.xml
Module Name: Thycotic.SecretServer
online version: https://thycotic-ps.github.io/thycotic.secretserver/commands/Search-TssDirectoryServiceDomain
schema: 2.0.0
title: Search-TssDirectoryServiceDomain
---

# Search-TssDirectoryServiceDomain

## SYNOPSIS
Search Directory Services domains

## SYNTAX

```
Search-TssDirectoryServiceDomain [-TssSession] <TssSession> [-DomainName <Int32>] [-IncludeInactive]
 [-SortBy <String>] [<CommonParameters>]
```

## DESCRIPTION
Search Directory Services domains

## EXAMPLES

### EXAMPLE 1
```
$session = New-TssSession -SecretServer https://alpha -Credential $ssCred
Search-TssDirectoryServiceDomain -TssSession $session -DomainName lab.local
```

Return the domain lab.local information

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

### -DomainName
Domain Name

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Domain

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeInactive
Include inactive domains

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

### -SortBy
Sort by specific property, default DomainName

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: DomainName
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TssDomainSummary
## NOTES
Requires TssSession object returned by New-TssSession

## RELATED LINKS

[https://thycotic-ps.github.io/thycotic.secretserver/commands/Search-TssDirectoryServiceDomain](https://thycotic-ps.github.io/thycotic.secretserver/commands/Search-TssDirectoryServiceDomain)

[https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/directory-services/Search-DirectoryServiceDomain.ps1](https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/directory-services/Search-DirectoryServiceDomain.ps1)

