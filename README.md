## Preface

This application should work with all Sailfish devices where the sysfs file `/sys/class/power_supply/battery/battery_charging_enabled` is present.

It was only tested with a Sony Xperia X, though.

## How it works

It listenes on several *ContextProperty*s ([have a look here](https://git.merproject.org/mer-core/statefs-providers/blob/master/src/power_udev/)) and reacts by writing either "1" or "0" to `/sys/class/power_supply/battery/battery_charging_enabled`
