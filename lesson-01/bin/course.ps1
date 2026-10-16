# Windows launcher (PowerShell 5.1+). Same behaviour as bin/course:
# run a command in the course container with this folder mounted at /work.
#
#   .\bin\course.ps1                       interactive shell
#   .\bin\course.ps1 west build ...        run one command
#   .\bin\course.ps1 doctor                check the toolchain
#
# Requires Docker Desktop (running). Env: COURSE_IMAGE, COURSE_ENGINE.
# Keep the folder on a Windows drive (not inside a WSL distribution).
$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# Course checkout: bin\ lives in toolchain\. Student package: bin\ is at the root.
if (Test-Path (Join-Path $here '..\versions.env')) {
    $root = (Resolve-Path (Join-Path $here '..\..')).Path
    $pins = Join-Path $here '..\versions.env'
} else {
    $root = (Resolve-Path (Join-Path $here '..')).Path
    $pins = Join-Path $here 'versions.env'
}

$version = $null
$repository = $null
foreach ($line in Get-Content $pins) {
    if ($line -match '^TOOLCHAIN_VERSION=(.+)$') { $version = $Matches[1].Trim() }
    if ($line -match '^IMAGE_REPOSITORY=(.+)$') { $repository = $Matches[1].Trim() }
}
if (-not $version) { throw "TOOLCHAIN_VERSION not found in $pins" }
if (-not $repository) { throw "IMAGE_REPOSITORY not found in $pins" }

$engine = if ($env:COURSE_ENGINE) { $env:COURSE_ENGINE } else { 'docker' }
if (-not (Get-Command $engine -ErrorAction SilentlyContinue)) {
    Write-Host "error: '$engine' was not found. Install Docker Desktop, start it, then open a new terminal."
    Write-Host "       https://www.docker.com/products/docker-desktop/"
    exit 2
}
$localImage = ($repository -replace '^.*/', '') + ":$version"
$publishedImage = "${repository}:$version"

& $engine info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "error: Docker is installed but its engine is not running."
    Write-Host "       Start Docker Desktop and wait until it says the engine is running, then retry."
    Write-Host "       If it reports an engine or WSL 2 error (for example dockerDesktopLinuxEngine),"
    Write-Host "       install WSL 2: run 'wsl --install' in an administrator PowerShell, restart the"
    Write-Host "       computer, and start Docker Desktop again. You do not need to use WSL yourself."
    exit 2
}

# Image: COURSE_IMAGE, else the locally built tag, else the published one.
if ($env:COURSE_IMAGE) {
    $image = $env:COURSE_IMAGE
} else {
    & $engine image inspect $localImage *> $null
    $image = if ($LASTEXITCODE -eq 0) { $localImage } else { $publishedImage }
}

& $engine image inspect $image *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Error "image $image not found. Download it once with: $engine pull $publishedImage"
    exit 2
}

# Same relative directory inside the container.
$cwd = (Get-Location).Path
$workdir = '/work'
if ($cwd -eq $root) {
    $workdir = '/work'
} elseif ($cwd.StartsWith($root + '\')) {
    $workdir = '/work/' + $cwd.Substring($root.Length + 1).Replace('\', '/')
}

$cmd = @($args)
if ($cmd.Count -eq 0) { $cmd = @('bash', '-l') }
if ($cmd[0] -eq 'doctor') { $cmd = @('course-doctor') }

$tty = @()
if (-not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected) { $tty = @('-it') }

# No --user: Docker Desktop maps file ownership of bind mounts itself.
& $engine run --rm @tty -v "${root}:/work" -w $workdir -e HOME=/tmp/home $image @cmd
exit $LASTEXITCODE
