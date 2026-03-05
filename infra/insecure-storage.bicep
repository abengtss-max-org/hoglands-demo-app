// =============================================================================
// Intentionally Insecure Bicep — for Defender for DevOps Demo
// =============================================================================
// This file contains deliberate security misconfigurations that Microsoft
// Security DevOps (Template Analyzer / Terrascan) will detect.
// =============================================================================

param location string = resourceGroup().location
param storagePrefix string = 'stinsecure'

// ISSUE 1: Storage account with insecure settings
resource insecureStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${storagePrefix}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    // ISSUE: No HTTPS enforcement
    supportsHttpsTrafficOnly: false

    // ISSUE: Old TLS version
    minimumTlsVersion: 'TLS1_0'

    // ISSUE: Public blob access enabled
    allowBlobPublicAccess: true

    // ISSUE: No network restrictions (public access)
    // Missing: networkAcls with default deny

    // ISSUE: Shared key access enabled
    allowSharedKeyAccess: true

    // ISSUE: No encryption scope configured
    encryption: {
      services: {
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// ISSUE 2: SQL Server with insecure settings
resource insecureSqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: 'sql-insecure-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    // ISSUE: SQL authentication enabled (should use AAD only)
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'P@ssw0rd123!'  // ISSUE: Hardcoded password

    // ISSUE: No AAD-only authentication
    // ISSUE: No auditing configured
    // ISSUE: No threat detection configured

    // ISSUE: Minimal TLS version not set to 1.2
    minimalTlsVersion: '1.0'

    // ISSUE: Public network access enabled
    publicNetworkAccess: 'Enabled'
  }
}

// ISSUE 3: SQL Firewall rule allowing all Azure services
resource sqlFirewallAll 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = {
  parent: insecureSqlServer
  name: 'AllowAllAzureIPs'
  properties: {
    // ISSUE: Allows ALL Azure IPs (too permissive)
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// ISSUE 4: SQL Firewall rule allowing all IPs
resource sqlFirewallOpen 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = {
  parent: insecureSqlServer
  name: 'AllowAll'
  properties: {
    // ISSUE: Open to the entire internet
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

// ISSUE 5: Web app without HTTPS redirect
resource insecureWebApp 'Microsoft.Web/sites@2023-01-01' = {
  name: 'app-insecure-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    httpsOnly: false  // ISSUE: HTTPS not enforced
    siteConfig: {
      // ISSUE: Old .NET framework version
      netFrameworkVersion: 'v4.0'

      // ISSUE: FTP enabled
      ftpsState: 'AllAllowed'

      // ISSUE: HTTP 2.0 not enabled
      http20Enabled: false

      // ISSUE: Minimum TLS version too low
      minTlsVersion: '1.0'

      // ISSUE: Remote debugging enabled
      remoteDebuggingEnabled: true
    }
  }
}
