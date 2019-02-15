param (
  [Parameter(Mandatory=$true)][string]$ARMOutput
)

$json = $ARMOutput | convertfrom-json
$json.PSObject.Properties | ForEach-Object {
    Write-Host "##vso[task.setvariable variable=$($_.name);]$($_.value.value)"
}