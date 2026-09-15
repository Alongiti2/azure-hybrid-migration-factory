targetScope = 'subscription'

@description('Azure region for Contoso resources.')
param location string = 'westus2'

@description('Deployment environment.')
@allowed([
  'dev'
  'test'
  'stage'
  'prod'
])
param environment string = 'dev'

@description('Project name used in resource naming.')
param projectName string = 'contoso-migration'

@description('Hub VNet address space.')
param hubVnetAddressPrefix string = '10.100.0.0/16'

@description('Web spoke address space.')
param webVnetAddressPrefix string = '10.110.0.0/16'

@description('Application spoke address space.')
param appVnetAddressPrefix string = '10.120.0.0/16'

@description('Data spoke address space.')
param dataVnetAddressPrefix string = '10.130.0.0/16'

@description('Management spoke address space.')
param managementVnetAddressPrefix string = '10.140.0.0/16'

var commonTags = {
  Environment: environment
  Project: projectName
  ManagedBy: 'Bicep'
  MigrationFactory: 'Azure-Hybrid-Migration-Factory'
}

var networkResourceGroupName = 'rg-${projectName}-${environment}-network'
var monitoringResourceGroupName = 'rg-${projectName}-${environment}-monitoring'
var securityResourceGroupName = 'rg-${projectName}-${environment}-security'

resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: networkResourceGroupName
  location: location
  tags: commonTags
}

resource monitoringResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: monitoringResourceGroupName
  location: location
  tags: commonTags
}

resource securityResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: securityResourceGroupName
  location: location
  tags: commonTags
}

module hubVnet './modules/hub-vnet.bicep' = {
  name: 'deploy-hub-vnet'
  scope: networkResourceGroup
  params: {
    location: location
    environment: environment
    addressPrefix: hubVnetAddressPrefix
    tags: commonTags
  }
}

module webSpoke './modules/spoke-vnet.bicep' = {
  name: 'deploy-web-spoke'
  scope: networkResourceGroup
  params: {
    location: location
    environment: environment
    workloadName: 'web'
    addressPrefix: webVnetAddressPrefix
    tags: commonTags
subnets: [
  {
    name: 'snet-web'
    addressPrefix: '10.110.10.0/24'
  }
  {
    name: 'snet-web-private'
    addressPrefix: '10.110.20.0/24'
  }
]
  }
}

module appSpoke './modules/spoke-vnet.bicep' = {
  name: 'deploy-app-spoke'
  scope: networkResourceGroup
  params: {
    location: location
    environment: environment
    workloadName: 'app'
    addressPrefix: appVnetAddressPrefix
    tags: commonTags
  }
}

module dataSpoke './modules/spoke-vnet.bicep' = {
  name: 'deploy-data-spoke'
  scope: networkResourceGroup
  params: {
    location: location
    environment: environment
    workloadName: 'data'
    addressPrefix: dataVnetAddressPrefix
    tags: commonTags
  }
}

module managementSpoke './modules/spoke-vnet.bicep' = {
  name: 'deploy-management-spoke'
  scope: networkResourceGroup
  params: {
    location: location
    environment: environment
    workloadName: 'management'
    addressPrefix: managementVnetAddressPrefix
    tags: commonTags
  }
}
// ============================================================
// Hub-to-Spoke VNet Peering
// ============================================================

module hubToWebPeering './modules/vnet-peering.bicep' = {
  name: 'peer-hub-to-web'
  scope: networkResourceGroup
  params: {
    localVnetName: hubVnet.outputs.vnetName
    remoteVnetId: webSpoke.outputs.vnetId
    peeringName: 'peer-hub-to-web'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

module webToHubPeering './modules/vnet-peering.bicep' = {
  name: 'peer-web-to-hub'
  scope: networkResourceGroup
  params: {
    localVnetName: webSpoke.outputs.vnetName
    remoteVnetId: hubVnet.outputs.vnetId
    peeringName: 'peer-web-to-hub'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

module hubToAppPeering './modules/vnet-peering.bicep' = {
  name: 'peer-hub-to-app'
  scope: networkResourceGroup
  params: {
    localVnetName: hubVnet.outputs.vnetName
    remoteVnetId: appSpoke.outputs.vnetId
    peeringName: 'peer-hub-to-app'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
  dependsOn: [
    hubToWebPeering
  ]
}

module appToHubPeering './modules/vnet-peering.bicep' = {
  name: 'peer-app-to-hub'
  scope: networkResourceGroup
  params: {
    localVnetName: appSpoke.outputs.vnetName
    remoteVnetId: hubVnet.outputs.vnetId
    peeringName: 'peer-app-to-hub'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

module hubToDataPeering './modules/vnet-peering.bicep' = {
  name: 'peer-hub-to-data'
  scope: networkResourceGroup
  params: {
    localVnetName: hubVnet.outputs.vnetName
    remoteVnetId: dataSpoke.outputs.vnetId
    peeringName: 'peer-hub-to-data'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
  dependsOn: [
    hubToAppPeering
  ]
}

module dataToHubPeering './modules/vnet-peering.bicep' = {
  name: 'peer-data-to-hub'
  scope: networkResourceGroup
  params: {
    localVnetName: dataSpoke.outputs.vnetName
    remoteVnetId: hubVnet.outputs.vnetId
    peeringName: 'peer-data-to-hub'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

module hubToManagementPeering './modules/vnet-peering.bicep' = {
  name: 'peer-hub-to-management'
  scope: networkResourceGroup
  params: {
    localVnetName: hubVnet.outputs.vnetName
    remoteVnetId: managementSpoke.outputs.vnetId
    peeringName: 'peer-hub-to-management'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
  dependsOn: [
    hubToDataPeering
  ]
}

module managementToHubPeering './modules/vnet-peering.bicep' = {
  name: 'peer-management-to-hub'
  scope: networkResourceGroup
  params: {
    localVnetName: managementSpoke.outputs.vnetName
    remoteVnetId: hubVnet.outputs.vnetId
    peeringName: 'peer-management-to-hub'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

output networkResourceGroup string = networkResourceGroup.name
output monitoringResourceGroup string = monitoringResourceGroup.name
output securityResourceGroup string = securityResourceGroup.name
output hubVnetName string = hubVnet.outputs.vnetName
output webSpokeName string = webSpoke.outputs.vnetName
output appSpokeName string = appSpoke.outputs.vnetName
output dataSpokeName string = dataSpoke.outputs.vnetName
output managementSpokeName string = managementSpoke.outputs.vnetName
