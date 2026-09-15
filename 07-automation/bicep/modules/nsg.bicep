@description('Azure region for the NSG.')
param location string

@description('NSG name.')
param nsgName string

@description('Tags applied to the NSG.')
param tags object

@description('Security rules for the NSG.')
param securityRules array = []

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      for rule in securityRules: {
        name: rule.name
        properties: {
          priority: rule.priority
          direction: rule.direction
          access: rule.access
          protocol: rule.protocol
          sourcePortRange: rule.sourcePortRange
          destinationPortRange: rule.destinationPortRange
          sourceAddressPrefix: rule.sourceAddressPrefix
          destinationAddressPrefix: rule.destinationAddressPrefix
        }
      }
    ]
  }
}

output nsgName string = nsg.name
output nsgId string = nsg.id
