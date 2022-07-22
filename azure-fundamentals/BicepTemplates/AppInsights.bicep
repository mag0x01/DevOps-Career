@description('The resource name.')
param AppInsightsName string 
@description('The resource location.')
param AppInsightsLocation string 
param AppInsightsType string = 'web'
param RequestSource string = 'rest'
param AppInsightsTags object 


resource APPIns 'Microsoft.Insights/components@2015-05-01' =  {
  name: AppInsightsName
  location: AppInsightsLocation
  tags: AppInsightsTags
  kind: 'web'
  properties: {
    Application_Type: AppInsightsType
    Flow_Type: 'Bluefield'
    Request_Source: RequestSource
  }
}

output APP_ID string = APPIns.id
output APP_NAME string = APPIns.name
