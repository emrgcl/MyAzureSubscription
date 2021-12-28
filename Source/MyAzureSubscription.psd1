@{
	# Script module or binary module file associated with this manifest
	RootModule = 'MyAzureSubscription.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.1'
	
	# ID used to uniquely identify this module
	GUID = 'e6a866eb-bc5b-4700-a476-18a8b89b12db'
	
	# Author of this module
	Author = 'Emre Güçlü'
	
	# Company or vendor of this module
	CompanyName = 'Microsoft'
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2021 Emre Güçlü'
	
	# Description of the functionality provided by this module
	Description = 'Tools for Azure Subscription Management'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		#@{ ModuleName='PSFramework'; ModuleVersion='1.0.19' }
	)
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\GPOTools.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\MyAzureSubscription.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	#FormatsToProcess = @('xml\MyAzureSubscription.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
		'Enable-RDPandSSHForMyIP'
		'Start-MyVm'
	)
	
	# Cmdlets to export from this module
	CmdletsToExport = @()
	
	# Variables to export from this module
	VariablesToExport = @()
	
	# Aliases to export from this module
	AliasesToExport = @()
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			# ProjectUri = ''
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}