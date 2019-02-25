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
            Get-AzureRMResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue  | Should Not BeNullOrEmpty
        }
    }

    Context 'Credentials' {
        It 'test-developer has credentials' {
            Test-Path -Path  $AgentTempDirectory/test-developer.json | Should Be $true
        }
    }

    Context 'Developer' {

        BeforeAll {
            Set-Location ./tests/interactive-login-bypasser/
            $chrome_process = Start-Process -FilePath "./latest/chrome" -ArgumentList "--headless","--disable-gpu","--remote-debugging-port=9222" -PassThru
            npm install
            node index.js $AgentTempDirectory/test-developer.json
            $chrome_process.Kill()
        }

        It 'It should not have access to services' {
            kubectl get services | Should BeNullOrEmpty
        }

        It 'It should have access to pods' {
            kubectl get pods | Should Not BeNullOrEmpty
        }
    }
}