Function InitializeBuildVars {
	switch ($Env:VC_VERSION) {
		'vc14' {
			If (-not (Test-Path $Env:VS120COMNTOOLS)) {
				Throw'The VS120COMNTOOLS environment variable is not set. Check your VS installation'
			}

			$Env:VSDEVCMD = ($Env:VS120COMNTOOLS -replace '\\$', '') + '\VsDevCmd.bat'
			Break
		}
		'vc15' {
			If (-not (Test-Path $Env:VS140COMNTOOLS)) {
				Throw'The VS140COMNTOOLS environment variable is not set. Check your VS installation'
			}

			$Env:VSDEVCMD = ($Env:VS140COMNTOOLS -replace '\\$', '') + '\VsDevCmd.bat'
			Break
		}
		default {
			$Env:VSDEVCMD = Get-ChildItem -Path "${Env:ProgramFiles(x86)}" -Filter "VsDevCmd.bat" -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }

			If ("$Env:VSDEVCMD" -eq "") {
				Throw 'Unable to find VsDevCmd. Check your VS installation'
			}
		}
	}

	If ($Env:PLATFORM -eq 'x64') {
		$Env:ARCH = 'x86_amd64'
	} Else {
		$Env:ARCH = 'x86'
	}

	$Env:ENABLE_EXT = "--enable-{0}" -f ("${Env:EXTNAME}" -replace "_","-")

	$SearchInFolder = (Get-Item $Env:VSDEVCMD).Directory.Parent.Parent.FullName
	$Env:VCVARSALL = Get-ChildItem -Path "$SearchInFolder" -Filter "vcvarsall.bat" -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
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

	$Env:RELEASE_FOLDER = "${Env:APPVEYOR_BUILD_FOLDER}\${Env:RELEASE_SUBFOLDER}"
	$Env:RELEASE_ZIPBALL = "${Env:EXTNAME}_${Env:PLATFORM}_${Env:VC_VERSION}_php${Env:PHP_VERSION}_${Env:APPVEYOR_BUILD_VERSION}"
}
