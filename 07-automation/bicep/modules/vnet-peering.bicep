@description('Name of the local virtual network.')
param localVnetName string

@description('Resource ID of the remote virtual network.')
param remoteVnetId string

@description('Name used for the VNet peering.')
param peeringName string

@description('Allow traffic between the peered virtual networks.')
param allowVirtualNetworkAccess bool = true

@description('Allow forwarded traffic from the remote virtual network.')
param allowForwardedTraffic bool = true

@description('Allow gateway transit through this virtual network.')
param allowGatewayTransit bool = false

@description('Use the remote virtual network gateway.')
param useRemoteGateways bool = false

resource localVnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: localVnetName
}

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: localVnet
  name: peeringName
  properties: {
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
  }
}

output peeringName string = peering.name
