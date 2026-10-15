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
foreach ($line in Get-Content $pins) {
    if ($line -match '^TOOLCHAIN_VERSION=(.+)$') { $version = $Matches[1].Trim() }
}
if (-not $version) { throw "TOOLCHAIN_VERSION not found in $pins" }

$image  = if ($env:COURSE_IMAGE)  { $env:COURSE_IMAGE }  else { "embedded-iot-course:$version" }
$engine = if ($env:COURSE_ENGINE) { $env:COURSE_ENGINE } else { 'docker' }

& $engine image inspect $image *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Error "image $image not found. Load it with: docker load -i <file>.tar.gz"
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
