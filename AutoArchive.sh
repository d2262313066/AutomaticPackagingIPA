##########证书还是要都导入到打包的电脑里面#########

#注意：脚本目录和xxxx.xcodeproj要在同一个目录，如果放到其他目录，请自行修改脚本。

#工程名字(Target名字)
Project_Name="工程文件夹名称"

#AppStore版本的Bundle ID
AppStoreBundleID="你的Bundle ID"

#provision file的名称 (#########此文件需要与xxxx.xcodeproj同一个目录#########)
MOBILE_PROVISION_NAME="Provision File，不需要带后缀"




#配置环境，Release或者Debug
Configuration="Release"

#将描述文件放入目录
MobileProvisionFile=./${MOBILE_PROVISION_NAME}.mobileprovision
#创建plist文件
#touch ./${MOBILE_PROVISION_NAME}.plist
/usr/libexec/plistbuddy -c Set: ./${MOBILE_PROVISION_NAME}.plist

#将描述文件转换成plist
MobileProvisonPlist=./${MOBILE_PROVISION_NAME}.plist
#echo "MobileProvisonPlist = ${MobileProvisonPlist}"

security cms -D -i $MobileProvisionFile > $MobileProvisonPlist

#获取开发者团队名称
DEVELOPMENT_TEAM_NAME=`/usr/libexec/PlistBuddy -c "Print TeamName" $MobileProvisonPlist`
echo "DEVELOPMENT_TEAM_NAME 为 ${DEVELOPMENT_TEAM_NAME}"

#获取团队ID
DEVELOPMENT_TEAM_ID=`/usr/libexec/PlistBuddy -c "Print TeamIdentifier:0" $MobileProvisonPlist`
echo "DEVELOPMENT_TEAM_ID 为 ${DEVELOPMENT_TEAM_ID}"

#拼接AppStore证书名#描述文件
APPSTORECODE_SIGN_IDENTITY="iPhone Distribution: ${DEVELOPMENT_TEAM_NAME} (${DEVELOPMENT_TEAM_ID})"
echo "APPSTORECODE_SIGN_IDENTITY 为 ${APPSTORECODE_SIGN_IDENTITY}"
#UUID
APPSTOREROVISIONING_PROFILE_NAME=`/usr/libexec/PlistBuddy -c "Print UUID" $MobileProvisonPlist`
echo "UUID 为 ${PROVISION_UUID}"

#删除导出选项Plist文件(如果存在)
#rm ./AppStoreExportOptionsPlist.plist

#创建导出选项Plist文件
/usr/libexec/plistbuddy -c Set: ./AppStoreExportOptionsPlist.plist

#赋值plist文件
AppStoreExportOptionsPlist=./AppStoreExportOptionsPlist.plist
AppStoreExportOptionsPlist=${AppStoreExportOptionsPlist}

#在plist文件添加数据
#删除字典(如果存在)
/usr/libexec/PlistBuddy -c "Delete :provisioningProfiles" ${AppStoreExportOptionsPlist}

#添加选项数据
/usr/libexec/PlistBuddy -c "Add :provisioningProfiles:${AppStoreBundleID} string ${APPSTOREROVISIONING_PROFILE_NAME}" ${AppStoreExportOptionsPlist}
/usr/libexec/PlistBuddy -c "Add :method string app-store" ${AppStoreExportOptionsPlist}

##############需要注意！############     修改工程文件info.plist里的CFBundleIdentifier
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${AppStoreBundleID}" ./${Project_Name}/info.plist



#clean下
xcodebuild clean -xcodeproj ./$Project_Name/$Project_Name.xcodeproj -configuration $Configuration -alltargets

#appstore脚本
xcodebuild -project $Project_Name.xcodeproj -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-appstore.xcarchive clean archive build  CODE_SIGN_IDENTITY="${APPSTORECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${APPSTOREROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AppStoreBundleID}"
xcodebuild -exportArchive -archivePath build/$Project_Name-appstore.xcarchive -exportOptionsPlist $AppStoreExportOptionsPlist -exportPath ~/Desktop/$Project_Name-appstore.ipa








