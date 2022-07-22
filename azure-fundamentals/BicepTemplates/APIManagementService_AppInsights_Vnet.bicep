// --- API Management Service ----
@description('Resource location.')
param location string = 'uksouth'
@description('The resource name.')
param apimName string = 'apim-01-test'
@description('Publisher name.')
param publisherName string = 'apim-01-test'
@description('Publisher email.')
param publisherEmail string = 'kidd@gmail.com'
@description('Resource tier.')
param tier string = 'Developer'
@description('Identity properties of the Api Management service resource.')
param identity string = 'None'
@description('Values/properties that help to categorize/organize resources.')
param Tags object
param capacity int = 1
param tripleDES bool = false
param http2 bool = false
param clientTls11 bool = false
param clientTls10 bool = false
param clientSsl30 bool = false
param backendTls11 bool = false
param backendTls10 bool = false
param backendSsl30 bool = false
//ApplicationInsights
param APIMAppInsightsOption bool = true
param APIMAppInsightsObject object
//VNET
@description('The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.	')
param virtualNetworkType string
@description('SubnetName')
param virtualNetworkSubnet string
@description('ResourceID')
param VNET_ID string


var CustomPropertiesNonConsumption = {
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': tripleDES
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': clientTls11
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': clientTls10
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': clientSsl30
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': backendTls11
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': backendTls10
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': backendSsl30
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': http2
}
var customPropertiesConsumption = {
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': clientTls11
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': clientTls10
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': backendTls11
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': backendTls10
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': backendSsl30
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': http2
}


resource API 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: tier
    capacity: capacity
  }
  identity: {
    type: identity
  }
 
  tags: Tags
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: {
      subnetResourceId: '${VNET_ID}/subnets/${virtualNetworkSubnet}'
    }
    customProperties: ((tier == 'Consumption') ? customPropertiesConsumption : CustomPropertiesNonConsumption)
  }
}

resource API_appInsights_logger 'Microsoft.ApiManagement/service/loggers@2019-01-01' = if (APIMAppInsightsOption) {
  name: '${API.name}/${APIMAppInsightsObject.name}'
  properties: {
    loggerType: 'applicationInsights'
    resourceId: APIMAppInsightsObject.id
    credentials: {
      instrumentationKey: (APIMAppInsightsOption ? reference(APIMAppInsightsObject.id, '2020-02-02-preview').InstrumentationKey : '')
   
    }
  }
}

//This is for diagnistics - enabling logging in applicationInsights 
resource API_appInsights_diagnostics 'Microsoft.ApiManagement/service/diagnostics@2021-01-01-preview' = {
  name: '${apimName}/applicationinsights'
  dependsOn: [
    API
    API_appInsights_logger
  ]
  properties: {
    alwaysLog: 'allErrors'
    httpCorrelationProtocol: 'Legacy'
    logClientIp: true
    verbosity: 'information'
    loggerId: API_appInsights_logger.id
    sampling: {
      samplingType: 'fixed'
      percentage: 100
    }
  }
}
