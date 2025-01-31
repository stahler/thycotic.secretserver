---
category: folders
title: "TssFolder"
last_modified_at: 2021-02-10T00:00:00-00:00
---

# TOPIC
    This help topic describes the TssFolder class in the Thycotic.SecretServer module.

# CLASS
    TssFolder

# INHERITANCE
    None

# DESCRIPTION
    The TssFolder class represents the FolderModel object returned by Secret Server endpoint /folders/{id}

# CONSTRUCTORS
    new()

# PROPERTIES
    ChildFolders [TssFolder[]]
        List of folders within this folder

    FolderName
        Folder name

    FolderPath
        Path of this folder

    FolderTypeId
        Folder type ID

    Id
        Folder ID

    InheritPermissions
        Whether the folder inherits permissions from its parent

    InheritSecretPolicy
        Whether the folder inherits the secret policy

    ParentFolderId
        Parent folder ID

    SecretPolicyId
        Secret policy ID

    SecretTemplates [TssFolderTemplate[]]
        List of templates that may be used to create secrets in this folder

# METHODS

# RELATED LINKS:
    TssFolderTemplate
    Get-TssFolder