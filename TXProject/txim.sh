//
//  txim.sh
//  TXProject
//
//  Created by Sam on 2019/5/23.
//  Copyright © 2019 sam. All rights reserved.
//

#ifndef txim_h
#define txim_h
#!/bin/sh
# Strip invalid architecturesstrip_invalid_archs() {binary="$1"echo "current binary ${binary}"# Get architectures for current filearchs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | rev)"stripped=""forarchin$archs;doif ! [[ "${ARCHS}" == *"$arch"* ]]; thenif[ -f"$binary"];then# Strip non-valid architectures in-placelipo -remove"$arch"-output"$binary""$binary"||exit1stripped="$stripped $arch"fifidoneif [[ "$stripped" ]]; thenecho "Stripped $binary of architectures:$stripped"fi}APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"# This script loops through the frameworks embedded in the application and# removes unused architectures.find"$APP_PATH"-name'*.framework'-type d |whileread-r FRAMEWORKdoFRAMEWORK_EXECUTABLE_NAME=$(defaultsread"$FRAMEWORK/Info.plist"CFBundleExecutable)FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"strip_invalid_archs "$FRAMEWORK_EXECUTABLE_PATH"done


#endif /* txim_h */
