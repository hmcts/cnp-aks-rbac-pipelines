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

    Context 'Develeloper' {
        It 'It should run in PWSH' {
            ./latest/chrome --headless --disable-gpu --remote-debugging-port=9222 https://www.chromestatus.com &
            export CHROME_PID=$!
            npm install && node index.js $(Agent.TempDirectory)/test-developer.json
            kill -9 $CHROME_PID

            kubectl get namespaces
        }
    }
}