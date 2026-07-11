# /etc/apparmor.d/usr.sbin.myapp — deny-by-default confinement. Load: apparmor_parser -r <file>
#include <tunables/global>
/usr/sbin/myapp {
  #include <abstractions/base>
  capability net_bind_service,
  network inet stream,
  /etc/myapp/** r,
  /var/lib/myapp/** rw,
  /var/log/myapp/*.log w,
  deny /etc/shadow rwklx,
  deny /root/** rwklx,
  deny /bin/** wx,
}
