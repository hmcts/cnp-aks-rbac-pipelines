$RootPath = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path

$Instances = @(@((Get-ChildItem $RootPath -filter '*.json' -Recurse).FullName) | Where-Object {$_ -ne $null})

if ($Instances.Count -eq 0)
{
    Write-Output 'No JSON files found in this folder'
}
else
{
    ## Create an empty array
    $TestCases = @()
    $Instances.ForEach{$TestCases += @{Instance = $_}}
    Describe 'Testing all JSON files' {

        Context "Check for non zero length files" {
            It "<Instance> file is greater than 0" -TestCases $TestCases {
                Param($Instance)
                (Get-ChildItem $Instance -Verbose).Length | Should BeGreaterThan 0
            }    
        }

        Context "Check for valid JSON files" {
            It "<Instance> file is valid JSON" -TestCases $TestCases {
                Param($Instance)
                {(Get-Content -raw $Instance) | ConvertFrom-Json } | should not throw
            }
        }
    }
}