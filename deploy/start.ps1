# SiYuan Vulnerable Webapp Deployment Script
# Start script for ZAST scanning

$ErrorActionPreference = "Stop"
$DeployDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Starting SiYuan vulnerable webapp..."

# Change to deployment directory
Set-Location $DeployDir

# Stop any existing container
docker compose down -v 2>$null | Out-Null

# Start the container
Write-Host "Deploying SiYuan container..."
docker compose up -d

# Wait for service to be ready
$maxRetries = 30
$retryCount = 0
$serviceReady = $false

Write-Host "Waiting for service to be ready..."

while ($retryCount -lt $maxRetries) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8090" -TimeoutSec 5 -UseBasicParsing -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 404) {
            $serviceReady = $true
            break
        }
    } catch {
        # Service not ready yet
    }

    Start-Sleep -Seconds 2
    $retryCount++
    Write-Host "Retry $retryCount/$maxRetries..."
}

if ($serviceReady) {
    Write-Host "SiYuan is ready at http://localhost:8090" -ForegroundColor Green
    Write-Host "Vulnerable endpoint: POST /api/template/renderSprig"
} else {
    Write-Host "Warning: Service may not be fully ready. Check with 'docker ps'" -ForegroundColor Yellow
}

# Verify container is running
docker ps --filter "name=siyuan-vuln"