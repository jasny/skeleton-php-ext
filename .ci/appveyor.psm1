Function InitializeBuildVars {
	switch ($Env:VC_VERSION) {
		'14' {
			If (-not (Test-Path $Env:VS120COMNTOOLS)) {
				Throw'The VS120COMNTOOLS environment variable is not set. Check your VS installation'
			}

			$Env:VSCOMNTOOLS = $Env:VS120COMNTOOLS -replace '\\$', ''
			Break
		}
		'15' {
			If (-not (Test-Path $Env:VS140COMNTOOLS)) {
				Throw'The VS140COMNTOOLS environment variable is not set. Check your VS installation'
			}

			$Env:VSCOMNTOOLS = $Env:VS140COMNTOOLS -replace '\\$', ''
			Break
		}
		default {
			Throw 'This script is designed to run with VS 14/15. Check your VS installation'
		}
	}

	If ($Env:PLATFORM -eq 'x64') {
		$Env:ARCH = 'x86_amd64'
	} Else {
		$Env:ARCH = 'x86'
	}

	$SearchFilter = 'vcvarsall.bat'
	$SearchInFolder = "${Env:VSCOMNTOOLS}\..\..\"

	$Env:ENABLE_EXT = "--enable-{0}" -f ("${Env:EXTNAME}" -replace "_","-")

	$Env:VCVARSALL_FILE = Get-ChildItem -Path $SearchInFolder -Filter $SearchFilter -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
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
	$Env:RELEASE_ZIPBALL = "${Env:EXTNAME}_${Env:PLATFORM}_vc${Env:VC_VERSION}_php${Env:PHP_VERSION}_${Env:APPVEYOR_BUILD_VERSION}"
}
