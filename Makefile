SHELL = /bin/sh

# --args:
#   diAccessLevel - access level of the dependency injection graph. If module is used by another module (like Cio) then you want `public`. Else, `internal`. 
#   moduleName - the name of the module that you are generating code for. 
#   imports - Import statements to be at the top of the generated files in case the file needs classes from other modules. Split by `-` (example: `imports=Cio-Foo-Bar`) 
generate:
	./binny sourcery --sources Sources/Common --templates Sources/Templates --output Sources/Common/autogenerated 
	./binny sourcery --sources Sources/DataPipeline --templates Sources/Templates --output Sources/DataPipeline/autogenerated --args imports=CioInternalCommon2
	./binny sourcery --sources Sources/MessagingPush --templates Sources/Templates --output Sources/MessagingPush/autogenerated --args imports=CioInternalCommon2
	./binny sourcery --sources Sources/MessagingPushAPN --templates Sources/Templates --output Sources/MessagingPushAPN/autogenerated --args imports=CioMessagingPush2-CioInternalCommon2
	./binny sourcery --sources Sources/MessagingPushFCM --templates Sources/Templates --output Sources/MessagingPushFCM/autogenerated --args imports=CioMessagingPush2-CioInternalCommon2
	./binny sourcery --sources Sources/MessagingInApp --templates Sources/Templates --output Sources/MessagingInApp/autogenerated --args imports=CioInternalCommon2-UIKit
	./binny sourcery --sources Sources/Migration --templates Sources/Templates --output Sources/Migration/autogenerated --args imports=CioInternalCommon2


lint:
	./binny swiftlint lint --strict

# specify swiftversion this way instead of .swift-version to (1) keep project files slim and (2) we can specify the version in a CI server matrix for multiple version testing. 
# use the min Swift version that we support/test against. 
format:
	./binny swiftformat . --swiftversion 5.3 && ./binny swiftlint lint --fix

# Check what code has not yet had documentation written for it. 
# Jazzy is a great tool that generates docs, yes, but also tells you what public facing code is missing docs. 
# This command will simply show you the output of the undocumented code of jazzy. It's not the most human-readable but it will do for now. 
check-undocumented:
	jazzy --module CioDataPipelines2 --swift-build-tool spm --output /tmp/CioDataPipelinesDocs > /dev/null 2>&1 && cat /tmp/CioDataPipelinesDocs/undocumented.json
	jazzy --module CioMessagingPush2 --swift-build-tool spm --output /tmp/CioMessagingPushDocs > /dev/null 2>&1 && cat /tmp/CioMessagingPushDocs/undocumented.json

# generates code reference docs for project 
doc: 
	jazzy --module CioDataPipelines2 --output /tmp/CioDataPipelinesDocs
	jazzy --module CioMessagingPushAPN2 --output /tmp/CioMessagingPushAPNDocs
	jazzy --module CioMessagingPushFCM --output /tmp/CioMessagingPushFCMDocs
	jazzy --module CioMessagingInApp --output /tmp/CioMessagingInApp

# generates code reference docs with all modules *combined* together. 
doc_combined:
	mkdir -p .build/sourcekitten/
	sourcekitten doc --module-name CioDataPipelines2 -- -scheme Customer.io-Package -destination 'platform=iOS Simulator,name=iPhone 8' > .build/sourcekitten/DataPipelines.json
	sourcekitten doc --module-name CioMessagingPushAPN2 -- -scheme Customer.io-Package -destination 'platform=iOS Simulator,name=iPhone 8' > .build/sourcekitten/MessagingPushAPN.json
	sourcekitten doc --module-name CioMessagingPushFCM -- -scheme Customer.io-Package -destination 'platform=iOS Simulator,name=iPhone 8' > .build/sourcekitten/MessagingPushFCM.json
	sourcekitten doc --module-name CioMessagingInApp -- -scheme Customer.io-Package -destination 'platform=iOS Simulator,name=iPhone 8' > .build/sourcekitten/MessagingInApp.json
	jazzy --title "Customer.io iOS SDK" --sourcekitten-sourcefile .build/sourcekitten/MessagingInApp.json,.build/sourcekitten/MessagingPushAPN.json,.build/sourcekitten/MessagingPushFCM.json,.build/sourcekitten/DataPipelines.json, --output /tmp/foodocs

# Setup a sample app for you to then compile. 
# 
# How to use: 
# make setup_sample_app app=CocoaPods-FCM
setup_sample_app:	
	cp "Apps/$(app)/BuildEnvironment.sample.swift" "Apps/$(app)/BuildEnvironment.swift" || true
	echo "⚠️ Enter the Customer.io workspace settings into Apps/$(app)/BuildEnvironment.swift ⚠️"

# Update cocoapods dependencies and update Podfile.lock lockfile with new versions. 
# This is meant to be used during development to update Customer.io SDK or other dependencies. 
# CI server should use install and not update. 
# 
# How to use: 
# make update_cocoapods_dependencies app=CocoaPods-FCM
update_cocoapods_dependencies:
	pod update --project-directory=Apps/$(app) || true 

# Install cocoapods dependencies with versions from lockfile (Podfile.lock)
# This is meant to be used by the CI server and after you pull code from github during development. 
# 
# How to use: 
# make install_cocoapods_dependencies app=CocoaPods-FCM
install_cocoapods_dependencies:
	pod install --project-directory=Apps/$(app) || true 
