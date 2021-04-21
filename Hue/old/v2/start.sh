# Sync database
/usr/share/hue/build/env/bin/hue syncdb --noinput
/usr/share/hue/build/env/bin/hue migrate

# Start hue
/usr/share/hue/build/env/bin/supervisor
