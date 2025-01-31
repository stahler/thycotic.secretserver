---
category: configurations
title: "TssConfigurationEmailSettings"
last_modified_at: 2021-04-04T00:00:00-00:00
---

# TOPIC
    This help topic describes the TssConfigurationEmailSettings class in the Thycotic.SecretServer module

# CLASS
    TssConfigurationEmailSettings

# INHERITANCE
    None

# DESCRIPTION
    The TssConfigurationEmailSettings class represents the ConfigurationEmailModel returned by Secret Server endpoint GET /configuration/general

# CONSTRUCTORS
    new()

# PROPERTIES
    FromEmailAddress: string
        All emails will be sent from this address

    SmtpCheckCertificateRevocation: boolean
        Check Certificate Revocation when in Implicit SSL Connection Mode

    SmtpDomain: string
        SMTP user domain

    SmtpPassword: string
        SMTP user password

    SmtpPort: integer (int32)
        Custom port, otherwise the default

    SmtpServer: string
        The resolvable and reachable host name for the outgoing SMTP server

    SmtpUseCredentials: boolean
        True if credentials are set, false if anonymous

    SmtpUseImplicitSSL: boolean
        Implicit SSL Connection Mode

    SmtpUserName: string
        SMTP user name

    SmtpUseSSL: boolean
        Use SSL to connect

# METHODS

# RELATED LINKS:
    TssConfiguration
    Get-TssConfiguration