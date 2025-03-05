# Define the root folder
$rootFolder = "SmartAI-Assistant"

# Create the backend folder structure
$backendFolders = @(
    "backend/app/api/v1",
    "backend/app/core",
    "backend/app/models",
    "backend/app/schemas",
    "backend/app/services",
    "backend/tests"
)

# Create the frontend folder structure
$frontendFolders = @(
    "frontend/src/components",
    "frontend/src/pages",
    "frontend/src/services",
    "frontend/public"
)

# Create the deployment folder structure
$deploymentFolders = @(
    "deployment/k8s"
)

# Create the docs folder structure
$docsFolders = @(
    "docs"
)

# Create the .github folder structure
$githubFolders = @(
    ".github/workflows"
)

# Combine all folders into a single array
$allFolders = $backendFolders + $frontendFolders + $deploymentFolders + $docsFolders + $githubFolders

# Create each folder
foreach ($folder in $allFolders) {
    $fullPath = Join-Path -Path $rootFolder -ChildPath $folder
    if (-not (Test-Path -Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath | Out-Null
        Write-Host "Created folder: $fullPath"
    } else {
        Write-Host "Folder already exists: $fullPath"
    }
}

# Create the files
$files = @(
    "backend/app/api/v1/auth.py",
    "backend/app/api/v1/tasks.py",
    "backend/app/api/v1/business.py",
    "backend/app/core/config.py",
    "backend/app/core/security.py",
    "backend/app/models/user.py",
    "backend/app/models/task.py",
    "backend/app/schemas/user.py",
    "backend/app/schemas/task.py",
    "backend/app/main.py",
    "backend/.env",
    "backend/requirements.txt",
    "backend/Dockerfile",
    "backend/gunicorn_config.py",
    "frontend/src/App.tsx",
    "frontend/tailwind.config.js",
    "frontend/tsconfig.json",
    "frontend/package.json",
    "frontend/vite.config.ts",
    "deployment/docker-compose.yml",
    "docs/API_REFERENCE.md",
    "docs/ARCHITECTURE.md",
    ".github/workflows/ci-cd.yml",
    ".gitignore",
    "README.md"
)

# Create each file
foreach ($file in $files) {
    $fullPath = Join-Path -Path $rootFolder -ChildPath $file
    if (-not (Test-Path -Path $fullPath)) {
        New-Item -ItemType File -Path $fullPath | Out-Null
        Write-Host "Created file: $fullPath"
    } else {
        Write-Host "File already exists: $fullPath"
    }
}

Write-Host "Folder structure and files created successfully."
