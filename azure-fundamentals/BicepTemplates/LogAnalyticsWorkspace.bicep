// Log Analytics workspace
@description('The resource name.')
param WorkspaceName string 
@description('The resource location.')
param WorkspaceLocation string
@description('The SKU (tier) of a workspace.	')
param sku string 
@description('Values/properties that help to categorize/organize resources.')
param Tags object


resource WORKSPACE 'Microsoft.OperationalInsights/workspaces@2021-06-01' =  {
  name: WorkspaceName
  location: WorkspaceLocation
  tags: Tags
  properties:{
    sku: {
      name: sku
    }
  }
}

output WORKSPACE_ID string = WORKSPACE.id
