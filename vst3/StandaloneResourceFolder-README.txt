Ensoniq EPS-16 Plus standalone application - external files
===========================================================

Add your own legally obtained EPS-16 Plus files to this EPS_files folder.
Firmware and operating-system images are copyrighted and are not included.

The standalone application searches, in order:

  1. EPS_files beside the application
     (beside "Ensoniq EPS-16 Plus.app" on macOS, beside the .exe on Windows)
  2. A per-user folder:
       macOS:   ~/Library/Application Support/Ensoniq EPS-16 Plus/EPS_files/
       Windows: %APPDATA%\Ensoniq EPS-16 Plus\EPS_files\
       Linux:   ~/.config/Ensoniq EPS-16 Plus/EPS_files/
  3. The AU/VST3 plug-in locations, so an existing plug-in installation is
     reused without copying any files:
       macOS:   ~/Library/Audio/Plug-Ins/VST3/EPS_files/ (and /Library/...)
       Windows: C:\Program Files\Common Files\VST3\EPS_files\

Preferred names:

  eps16plus-rom.bin   combined 128 KiB U28/U27 main ROM
  eps16plus-kpc.bin   32 KiB KPC 2.33 EPROM
  EPS130OS.img        819,200-byte logical OS disk

The two unchanged 64 KiB EPS-16 Plus 1.00F split ROMs (U28/U27) are also
accepted under any filename; EPS130OS.hfe and the original KPC filename
"Ensoniq EPS KPC2 v2.33 27c256.BIN" are recognized too.

If you add files while the application is running, quit and restart it so
the machine initializes from reset.

Audio and MIDI
--------------

Options > Audio/MIDI Settings selects the audio device, sample rate, buffer
size, input channels for sampling, and MIDI input/output devices. MIDI notes
36-96 play the 61-key EPS keyboard; the on-screen KEYBOARD panel works too.

Sampling: untick "Mute audio input" in the settings (it is on by default to
avoid feedback from a microphone into speakers), then use the EPS's own
SAMPLE workflow.

The application saves the complete machine state (instruments, sample RAM,
mounted disk) when it quits and restores it on the next launch. Options >
"Save current state..." / "Load a saved state..." keep named snapshots, and
"Reset to default state" starts from a cold boot.
