param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$AgentTempDirectory
)

#Invoke-Pester -script @{Path= './*.tests.ps1' ;Parameters = @{Environment = 'saat'}}
Describe 'RBAC Model' {

    Context 'Test Run' {
        It 'Deployment Target Resource Group Exists' {
            Write-Host $ResourceGroupName
            Get-AzureRMResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue  | Should Not BeNullOrEmpty
        }
    }

    Context 'Credentials' {
        It 'test-developer has credentials' {
            Write-Host "The agent temp directory is: $AgentTempDirectory"
            Test-Path -Path  $AgentTempDirectory/test-developer.json | Should Be $true
        }
    }
}