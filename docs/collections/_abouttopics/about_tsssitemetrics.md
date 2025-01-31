---
category: distributed-engines, sites
title: "TssSiteSummary"
last_modified_at: 2021-04-05T00:00:00-00:00
---

# TOPIC
    This help topic describes the TssSiteMetric class in the Thycotic.SecretServer module

# CLASS
    TssSiteMetric

# INHERITANCE
    None

# DESCRIPTION
    The TssSiteMetric class represents the SiteMetic object returned by Secret Server endpoint GET /distributed-engines/sites
    List of Metrics for this site such as ConnectionStatusOffline, ConnectionStatusOnline, ActivationStatusPending, LostConnection, and more. Only returned on a search when IncludeSiteMetrics is true.

# CONSTRUCTORS
    new()

# PROPERTIES
    MetricDisplayName: string
        Metric Display Name

    MetricName: string
        Metric Name

    MetricValue: integer (int32)
        Metric Value

# METHODS

# RELATED LINKS:
    TssSiteSummary
    Search-TssDistributedEngineSite