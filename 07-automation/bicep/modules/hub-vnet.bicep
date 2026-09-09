@description('Azure region for the hub VNet.')
param location string

@description('Deployment environment.')
param environment string

@description('Hub VNet address prefix.')
param addressPrefix string

@description('Tags applied to resources.')
param tags object

var vnetName = 'vnet-contoso-${environment}-hub'

resource hubVnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.100.1.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.100.2.0/26'
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.100.3.0/27'
        }
      }
      {
        name: 'snet-dns-inbound'
        properties: {
          addressPrefix: '10.100.4.0/28'
        }
      }
      {
        name: 'snet-dns-outbound'
        properties: {
          addressPrefix: '10.100.5.0/28'
        }
      }
      {
        name: 'snet-shared-services'
        properties: {
          addressPrefix: '10.100.10.0/24'
        }
      }
    ]
  }
}

output vnetName string = hubVnet.name
output vnetId string = hubVnet.id