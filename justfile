run:
    xcodebuild  && open "/Users/chenbao/Downloads/time/build/Release/time.app"
    # xcodebuild -scheme time && open "/Users/chenbao/Downloads/time/build/Release/time.app"

pack:
    rm -rf "/Users/chenbao/Downloads/untitled folder 4/time/time.app"
    rm -rf "/Users/chenbao/Downloads/untitled folder 4/time/time.dmg"
    cp -R "/Users/chenbao/Library/Developer/Xcode/DerivedData/time-dmxqqtptbsrvbkcuwcorscxmmhqg/Build/Products/Debug/time.app" "/Users/chenbao/Downloads/untitled folder 4/time/time.app"
    hdiutil create -volname "time" -srcfolder "/Users/chenbao/Downloads/untitled folder 4/time/" -ov -format UDZO "/Users/chenbao/Downloads/untitled folder 4/time/time.dmg"