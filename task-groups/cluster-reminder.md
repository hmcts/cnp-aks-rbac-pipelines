
# Clusters

|Field|Primary|Secondary|
|-|-|-|
|Task.AKS.ClusterName|$(AKS.Cluster.Primary.Name)|$(AKS.Cluster.Secondary.Name)|
|Task.AKS.ResourceGroup|$(AKS.Cluster.Primary.ResourceGroup)|$(AKS.Cluster.Secondary.ResourceGroup)|
|Task.AKS.SubnetId|$(aksPrimarySubnetId)|$(aksSecondarySubnetId)|
