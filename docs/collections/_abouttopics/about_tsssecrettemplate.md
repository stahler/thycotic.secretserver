---
category: secrets
title: "TssSecretTemplate"
last_modified_at: 2021-02-10T00:00:00-00:00
---

# TOPIC
    This help topic describes the TssSecretTemplate class in the Thycotic.SecretServer module.

# CLASS
    TssSecretTemplate

# INHERITANCE
    None

# DESCRIPTION
    The TssSecretTemplate class represents the SecretTemplateModel object returned by Secret Server endpoint /secret-templates/{id}.

# CONSTRUCTORS
    new()

# PROPERTIES
    Id
        Secret Template Id

    Name
        Secret Template name

    PasswordTypeId
        Password Type ID

    Fields [TssSecretTemplateField[]]

# METHODS

    [System.String] GetSlugName([string] DisplayName)
        Pulls the FieldSlugName from the fields object based on the Display Name

# RELATED LINKS:
    TssSecretTemplateField
    Get-TssSecretTemplate