{ ... }: {
  xdg.configFile."fcitx5/config".text = ''
    [Hotkey]
    EnumerateWithTriggerKeys=True
    EnumerateForwardKeys=
    EnumerateBackwardKeys=
    EnumerateSkipFirst=False
    ModifierOnlyKeyTimeout=250

    [Hotkey/TriggerKeys]
    0=Control+Shift_L

    [Hotkey/ActivateKeys]
    0=Control+Shift_L

    [Hotkey/DeactivateKeys]
    0=Control+Shift_L

    [Hotkey/AltTriggerKeys]
    0=

    [Behavior]
    ActiveByDefault=False
    resetStateWhenFocusIn=No
    ShareInputState=All
    PreloadInputMethod=True
  '';

  xdg.configFile."fcitx5/profile".text = ''
    [Groups/0]
    Name=Default
    Default Layout=us
    DefaultIM=bamboo

    [Groups/0/Items/0]
    Name=keyboard-us
    Layout=

    [Groups/0/Items/1]
    Name=bamboo
    Layout=

    [GroupOrder]
    0=Default
  '';

  xdg.configFile."fcitx5/conf/bamboo.conf".text = ''
    RestoreKeyStroke=
    InputMethod=VNI
    OutputCharset=Unicode
    SpellCheck=False
    Macro=False
    CapitalizeMacro=True
    AutoNonVnRestore=True
    ModernStyle=False
    FreeMarking=True
    DisplayUnderline=True
  '';
}
