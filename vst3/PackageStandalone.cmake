# Packages the standalone EPS-16 Plus application with an empty EPS_files
# folder, licence notices and platform-specific instructions.
#
# Inputs: SOURCE_APP (built .app bundle on macOS, executable elsewhere),
#         PACKAGE_DIR, ARCHIVE_NAME, PLATFORM_LABEL, RESOURCE_README,
#         THIRD_PARTY_NOTICES, JUCE_LICENSE.

if(NOT DEFINED SOURCE_APP OR NOT EXISTS "${SOURCE_APP}")
  message(FATAL_ERROR "SOURCE_APP does not name a built standalone application: ${SOURCE_APP}")
endif()
foreach(required PACKAGE_DIR ARCHIVE_NAME PLATFORM_LABEL RESOURCE_README)
  if(NOT DEFINED ${required})
    message(FATAL_ERROR "${required} is required")
  endif()
endforeach()

function(run_checked)
  execute_process(COMMAND ${ARGV} RESULT_VARIABLE RESULT)
  if(NOT RESULT EQUAL 0)
    message(FATAL_ERROR "Command failed (${RESULT}): ${ARGV}")
  endif()
endfunction()

set(FOLDER "Ensoniq-EPS-16-Plus-Standalone-${PLATFORM_LABEL}")
set(STAGE "${PACKAGE_DIR}/${FOLDER}")
set(ARCHIVE "${PACKAGE_DIR}/${ARCHIVE_NAME}")
file(REMOVE_RECURSE "${STAGE}")
file(REMOVE "${ARCHIVE}")
file(MAKE_DIRECTORY "${STAGE}/EPS_files")
configure_file("${RESOURCE_README}" "${STAGE}/EPS_files/README.txt" COPYONLY)
foreach(notice "${THIRD_PARTY_NOTICES}" "${JUCE_LICENSE}")
  if(notice AND EXISTS "${notice}")
    file(COPY "${notice}" DESTINATION "${STAGE}")
  endif()
endforeach()

if(CMAKE_HOST_APPLE)
  get_filename_component(APP_NAME "${SOURCE_APP}" NAME)
  run_checked(/usr/bin/ditto --norsrc --noextattr --noqtn --noacl
              "${SOURCE_APP}" "${STAGE}/${APP_NAME}")
  run_checked(/usr/bin/xattr -cr "${STAGE}/${APP_NAME}")
  # Ad-hoc signature: required for Apple Silicon. Not notarized.
  run_checked(/usr/bin/codesign --force --deep --sign - "${STAGE}/${APP_NAME}")
  run_checked(/usr/bin/codesign --verify --deep --strict --verbose=2
              "${STAGE}/${APP_NAME}")
  file(WRITE "${STAGE}/INSTALL-MAC.txt"
"Ensoniq EPS-16 Plus - standalone application for macOS\n\n"
"1. Copy 'Ensoniq EPS-16 Plus.app' and the 'EPS_files' folder together into\n"
"   /Applications (or any folder - keep them side by side).\n"
"2. Add your legally obtained ROM, KPC and OS files to EPS_files.\n"
"   Files already installed for the AU/VST3 plug-in in\n"
"   ~/Library/Audio/Plug-Ins/VST3/EPS_files are found automatically.\n"
"3. The app is not notarized. On first launch, right-click it and choose\n"
"   Open, or run in Terminal:\n"
"     xattr -dr com.apple.quarantine \"/Applications/Ensoniq EPS-16 Plus.app\"\n"
"4. Use Options > Audio/MIDI Settings to choose your audio interface and\n"
"   MIDI keyboard. Untick 'Mute audio input' to sample.\n")
  run_checked(/usr/bin/ditto -c -k --norsrc --noextattr --keepParent
              "${STAGE}" "${ARCHIVE}")
else()
  file(COPY "${SOURCE_APP}" DESTINATION "${STAGE}")
  if(WIN32 OR CMAKE_HOST_WIN32)
    file(WRITE "${STAGE}/INSTALL-WINDOWS.txt"
"Ensoniq EPS-16 Plus - standalone application for Windows x64\n\n"
"1. Unpack this folder anywhere, e.g. C:\\Program Files\\Ensoniq EPS-16 Plus\\\n"
"   Keep 'Ensoniq EPS-16 Plus.exe' and 'EPS_files' side by side.\n"
"2. Add your legally obtained ROM, KPC and OS files to EPS_files.\n"
"   Files already installed for the VST3 in\n"
"   C:\\Program Files\\Common Files\\VST3\\EPS_files are found automatically.\n"
"3. Start 'Ensoniq EPS-16 Plus.exe'. Windows SmartScreen may warn because\n"
"   the program is unsigned: choose More info > Run anyway.\n"
"4. Use Options > Audio/MIDI Settings to choose your audio device (ASIO\n"
"   is not included; use WASAPI or DirectSound) and MIDI keyboard.\n"
"   Untick 'Mute audio input' to sample.\n")
  else()
    file(WRITE "${STAGE}/INSTALL-LINUX.txt"
"Ensoniq EPS-16 Plus - standalone application for Linux x64\n\n"
"Keep the executable and EPS_files side by side, add your legally obtained\n"
"ROM, KPC and OS files to EPS_files, then run the executable. Requires ALSA.\n"
"Use Options > Audio/MIDI Settings to choose devices.\n")
  endif()
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E tar cf "${ARCHIVE}" --format=zip "${FOLDER}"
    WORKING_DIRECTORY "${PACKAGE_DIR}"
    RESULT_VARIABLE ZIP_RESULT)
  if(NOT ZIP_RESULT EQUAL 0)
    message(FATAL_ERROR "Could not create standalone archive")
  endif()
endif()

if(NOT EXISTS "${ARCHIVE}")
  message(FATAL_ERROR "Standalone archive was not created: ${ARCHIVE}")
endif()
message(STATUS "Created standalone package: ${ARCHIVE}")
