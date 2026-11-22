{
  # Unity Hub, together with the kernel parameter that stops it hard-freezing the
  # machine.
  #
  # ---------------------------------------------------------------------------
  # Why the kernel parameter is here
  # ---------------------------------------------------------------------------
  # Short version: Disabling USB autosuspend is the only thing that stopped
  # Unity Editor from hanging the machine. Everything below is a record of what was
  # actually measured, kept separate from what was only guessed at, so that a
  # future reader does not go chasing a mechanism that was never established.
  #
  # OBSERVED
  #
  # Symptom: between 37 seconds and ~12 minutes after Unity Editor 2022.3.22.f1 started,
  # the machine hard-froze. Not an application crash — a total stop. No panic, no oops,
  # no MCE, no amdgpu error, and nothing written to disk even with journald syncing
  # every 10 seconds. Magic SysRq did not respond, and the host stopped answering
  # ARP ("no route to host" from another machine on the LAN).
  #
  # The correlation was exact across twelve boots: nine boots with Unity Hub/Unity Editor
  # running all froze, three without it were clean — the longest a 7h50m run under
  # constant video playback. The machine had also been in daily use for a week
  # before Unity was first opened, without a single incident.
  #
  # Ruled out by testing, in order:
  #   - the NixOS config itself  (generations 125 and 126 had identical closures)
  #   - video playback           (7h50m clean with just the browser)
  #   - DRAM frequency           (EXPO II → JEDEC 4800 MT/s, still froze)
  #   - RAM integrity            (50GB of stress-ng --vm-keep --verify, clean)
  #   - GPU runtime power mgmt   (amdgpu.runpm=0, still froze)
  #   - the radeonsi OpenGL path (Unity forced to Vulkan, still froze)
  #   - Baloo file indexing      (indexer disabled, still froze)
  #   - PCIe Gen 5 signalling    (every link capped to Gen 4, still froze)
  #   - the project              (a brand-new empty project froze in 37 seconds)
  #
  # Considered but NOT tested: the PSU. It is a Seasonic Prime TX-1300 running at
  # roughly 40% of rated load, which makes it an unlikely culprit — but no load
  # test was ever run, so this is reasoning, not a result.
  #
  # THE FIX
  #
  # Pinning every USB device to power/control = "on" at runtime took the machine
  # from nine consecutive freezes straight to a clean run with Unity open.
  # usbcore.autosuspend=-1 makes that the default for every device, including any
  # hotplugged later. Note this rests on a single long clean run plus continued
  # uptime since — good evidence, but not the same weight as the nine-for-nine
  # correlation above.
  #
  # NOT KNOWN
  #
  # Why USB autosuspend matters here is unexplained. The starting hypothesis came
  # from a Unity forum thread describing an xHCI controller failing to resume and
  # taking the USB tree down with it:
  #
  #   https://discussions.unity.com/t/unity-editor-causes-full-system-freeze-on-arch-linux-wayland-x11-amd-7950x-nvidia-4070-ti-super/1674602
  #
  # That thread supplied the workaround, but its failure signature was never
  # reproduced here. The journals for every frozen boot contain zero occurrences
  # of "Controller not ready at resume" or "HC died", and no xHCI error of any
  # kind — only ordinary boot-time enumeration. Same workaround working is not
  # proof of the same bug.
  #
  # One observation actively resists a USB-only explanation: the machine stopped
  # answering ARP. Ethernet is on PCIe, not USB, so a dead xHCI alone should not
  # take the network stack down. Whatever the failure is, it appears to reach
  # further than the USB tree. The dead SysRq is likewise unexplained — a USB
  # keyboard behind a dead controller would account for it, but so would a genuine
  # kernel-wide hang, and nothing collected distinguishes the two.
  flake.nixosModules.unity =
    { pkgs, ... }:
    {
      # Never autosuspend USB devices — see the note above. Without this, Unity
      # freezes the entire machine within minutes. The mechanism is unknown; this is
      # an empirical workaround, not an understood fix.
      boot.kernelParams = [ "usbcore.autosuspend=-1" ];

      environment.systemPackages = [ pkgs.unityhub ];
    };

}
