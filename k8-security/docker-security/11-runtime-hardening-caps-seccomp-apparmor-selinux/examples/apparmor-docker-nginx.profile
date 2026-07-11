#include <tunables/global>
profile docker-nginx flags=(attach_disconnected,mediate_deleted) {
  #include <abstractions/base>
  network inet tcp,
  network inet udp,
  deny /bin/** wl,
  deny /sbin/** wl,
  deny /usr/bin/** wl,        # no writing to binaries
  deny /etc/shadow rwklx,     # never touch shadow
  /var/log/nginx/** w,
  /usr/share/nginx/html/** r,
}
