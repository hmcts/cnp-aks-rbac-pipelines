param
(
  [Parameter(Mandatory=$true)]
  [string]
  $ResourceGroupName,
  [Parameter(Mandatory=$true)]
  [string]
  $VnetCIDR,
  [Parameter(Mandatory=$true)]
  [string]
  $SubnetCIDR
)

<#
  Example
  test-vnet -vnetCIDR '10.0.0.0/8' -SubnetCIDR '10.1.0.0/16' -resourcegroupname 'aks-rpe-rg-test'
#>
$vnet = (Get-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroupName -ErrorAction 'SilentlyContinue') | Where-Object {$_.AddressSpace.AddressPrefixes -eq $VnetCIDR}
if ($vnet)
{
    $subnetCandidate = ($vnet.Subnets | Where-Object {$_.AddressPrefix -eq $SubnetCIDR})
    if ($subnetCandidate)
    {
      Write-Host ('###vso[task.setvariable variable=aksSubnetId]{0}' -f ($vnet.Subnets | Where-Object {$_.AddressPrefix -eq $SubnetCIDR}).id)
    }
    else
    {
      Write-Error ('Subnet {0} not present in vnet {1}' -f $SubnetCIDR, $VnetCIDR)
    }
}
else 
{
  Write-Output 'Continuing with a brand new infra...'
}

