@description('Azure region for the spoke VNet.')
param location string

@description('Deployment environment.')
param environment string

@description('Workload name for this spoke.')
param workloadName string

@description('Spoke VNet address prefix.')
param addressPrefix string

@description('Tags applied to resources.')
param tags object

var vnetName = 'vnet-contoso-${environment}-${workloadName}'

resource spokeVnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: union(tags, {
    Workload: workloadName
  })
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

output vnetName string = spokeVnet.name
output vnetId string = spokeVnet.id