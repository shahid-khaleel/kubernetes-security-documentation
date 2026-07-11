#!/usr/bin/env bash
# SELinux essentials (RHEL/Fedora). Stay in enforcing mode in prod.
getenforce                                   # Enforcing | Permissive | Disabled
sudo setenforce 1                            # enforcing (temp)
sestatus
ls -Z /var/www/html                          # view file contexts
ps -eZ | head                                # process domains
# Fix denials the RIGHT way (label), not by disabling SELinux:
sudo restorecon -Rv /var/www/html
sudo semanage fcontext -a -t httpd_sys_content_t "/webapp(/.*)?" && sudo restorecon -Rv /webapp
# Turn an AVC denial into a policy module (review before installing!):
sudo ausearch -m avc -ts recent | audit2allow -M mypol && sudo semodule -i mypol.pp
sudo setsebool -P httpd_can_network_connect on   # booleans instead of disabling
