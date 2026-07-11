# WHY mounting /var/run/docker.sock == handing over root
A container with the socket mounted can create a new container that mounts the host `/`:
  docker run -v /var/run/docker.sock:/var/run/docker.sock alpine ...
  # then inside: docker run -v /:/host --privileged alpine chroot /host sh  -> HOST ROOT
Detection: `docker inspect <c> | grep docker.sock`; Falco rule 'docker socket mounted'.
Prevention: never mount the socket into workloads; use a scoped API proxy if truly needed.
