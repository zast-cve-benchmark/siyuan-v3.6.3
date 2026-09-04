# SiYuan Vulnerable Webapp Deployment Script
# Stop script for ZAST scanning

$ErrorActionPreference = "Stop"
$DeployDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Stopping SiYuan vulnerable webapp..."

# Change to deployment directory
Set-Location $DeployDir

# Stop and remove containers
docker compose down -v

# Verify cleanup
$containers = docker ps -a --filter "name=siyuan-vuln" --format "{{.Names}}"
if ($containers -contains "siyuan-vuln") {
    Write-Host "Warning: Container still exists" -ForegroundColor Yellow
} else {
    Write-Host "SiYuan container stopped and removed" -ForegroundColor Green
}

# Show remaining containers
docker ps