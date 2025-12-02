Function Get-VsInstallPath {
        param (
                [Parameter(Mandatory=$false)] [System.String] $VersionRange
        )

        $ProgramFilesX86 = ${Env:ProgramFiles(x86)}
        $VsWhere = [System.IO.Path]::Combine($ProgramFilesX86, 'Microsoft Visual Studio', 'Installer', 'vswhere.exe')

        if (Test-Path $VsWhere) {
                $Arguments = @(
                        '-latest',
                        '-requires', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64',
                        '-property', 'installationPath'
                )

                if ($VersionRange) {
                        $Arguments += @('-version', $VersionRange)
                }

                $InstallPath = & $VsWhere @Arguments

                if ($LASTEXITCODE -eq 0 -and $InstallPath) {
                        return $InstallPath.Trim()
                }
        }

        return $null
}

Function InitializeBuildVars {
        $InstallPath = $null
        $DevEnvPreconfigured = [bool]$Env:VSCMD_VER

        if (-not $DevEnvPreconfigured) {
                switch ($Env:VC_VERSION) {
                        'vc14' {
                                If (-not (Test-Path $Env:VS120COMNTOOLS)) {
                                        Throw 'The VS120COMNTOOLS environment variable is not set. Check your VS installation'
                                }

                                $Env:VSDEVCMD = ($Env:VS120COMNTOOLS -replace '\\$', '') + '\\VsDevCmd.bat'
                                Break
                        }
                        'vc15' {
                                If (-not (Test-Path $Env:VS140COMNTOOLS)) {
                                        Throw 'The VS140COMNTOOLS environment variable is not set. Check your VS installation'
                                }

                                $Env:VSDEVCMD = ($Env:VS140COMNTOOLS -replace '\\$', '') + '\\VsDevCmd.bat'
                                Break
                        }
                        default {
                                $VersionRange = $null
                                $ProgramFilesX86 = ${Env:ProgramFiles(x86)}

                                if ($Env:VC_VERSION -match '^vs([0-9]+)$') {
                                        $VsMajor = [int]$Matches[1]
                                        $NextMajor = $VsMajor + 1
                                        $VersionRange = "[${VsMajor}.0,${NextMajor}.0)"
                                }

                                $InstallPath = Get-VsInstallPath -VersionRange $VersionRange

                                if (-not $InstallPath) {
                                        $Env:VSDEVCMD = Get-ChildItem -Path $ProgramFilesX86 -Filter "VsDevCmd.bat" -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | Select-Object -First 1
                                } else {
                                        $Env:VSDEVCMD = Join-Path $InstallPath "Common7\Tools\VsDevCmd.bat"
                                }

                                If (-not $Env:VSDEVCMD -or -not (Test-Path $Env:VSDEVCMD)) {
                                        Throw 'Unable to find VsDevCmd. Check your VS installation'
                                }
                        }
                }

                if (-not $InstallPath) {
                        $InstallPath = (Get-Item $Env:VSDEVCMD).Directory.Parent.Parent.FullName
                }

                $Env:VCVARSALL = Get-ChildItem -Path $InstallPath -Filter "vcvarsall.bat" -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName } | Select-Object -First 1

                if (-not $Env:VCVARSALL -or -not (Test-Path $Env:VCVARSALL)) {
                        Throw 'Unable to find vcvarsall.bat. Check your VS installation'
                }
        }

        If ($Env:PLATFORM -eq 'x64') {
                $Env:ARCH = 'x86_amd64'
        } Else {
                $Env:ARCH = 'x86'
        }

        $Env:ENABLE_EXT = "--enable-{0}" -f ("${Env:EXTNAME}" -replace "_", "-")
}

Function InitializeReleaseVars {
        If ($Env:PLATFORM -eq 'x86') {
                If ($Env:BUILD_TYPE -Match "nts-Win32") {
                        $Env:RELEASE_SUBFOLDER = "Release"
                } Else {
                        $Env:RELEASE_SUBFOLDER = "Release_TS"
                }
        } Else {
                If ($Env:BUILD_TYPE -Match "nts-Win32") {
                        $Env:RELEASE_SUBFOLDER = "${Env:PLATFORM}\Release"
                } Else {
                        $Env:RELEASE_SUBFOLDER = "${Env:PLATFORM}\Release_TS"
                }
        }

        $Workspace = $Env:GITHUB_WORKSPACE
        if (-not $Workspace) {
                $Workspace = $Env:APPVEYOR_BUILD_FOLDER
        }

        $Env:RELEASE_FOLDER = "${Workspace}\${Env:RELEASE_SUBFOLDER}"

        $BuildVersion = $Env:GITHUB_RUN_NUMBER
        if (-not $BuildVersion) {
                $BuildVersion = $Env:APPVEYOR_BUILD_VERSION
        }

        $Env:RELEASE_ZIPBALL = "${Env:EXTNAME}_${Env:PLATFORM}_${Env:VC_VERSION}_php${Env:PHP_VERSION}_${BuildVersion}"
}
