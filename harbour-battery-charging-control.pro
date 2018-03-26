TEMPLATE = subdirs

enableCharging.subdir = helpers/enableCharging
disableCharging.subdir = helpers/disableCharging

main.depends = enableCharging disableCharging

SUBDIRS += enableCharging \
    disableCharging \
    main

# show rpm dir in project explorer
OTHER_FILES += $$files(rpm/*) README.md
