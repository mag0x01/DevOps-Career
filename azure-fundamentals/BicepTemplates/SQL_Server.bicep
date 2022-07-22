param serverName string
param location string = resourceGroup().location
param adminUserName string
param tagsResourceType string
param tagsScope string
param tagsPlatform string

param tags object = {
  Scope: tagsScope
  Type: tagsResourceType
  Platform: tagsPlatform
}

var adminUserNamePassword = 'TEMPORARYPASSWORD123!!'

resource server 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: adminUserName
    administratorLoginPassword: adminUserNamePassword
  }
  tags: tags
}

resource firewall 'Microsoft.Sql/servers/firewallRules@2020-11-01-preview' = {
  name: '${serverName}/AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
  dependsOn: [
    server
  ]
}

output SQL_Server_Id string = server.id


