# CI worker capacity

Cutline's OCI archive and Docker runtime checks exhausted the CI worker's 20 GiB
root disk and Kubernetes evicted active runners. Proxmox VM 104 on machine-2 now
has an additional 64 GiB disk with serial `ci-storage-v1` (scsi1).

This one-time Argo Job validates the node, machine ID, root LV/VG UUIDs and exact
disk serial/size before making changes. It refuses disks with existing signatures
or partitions and records intent plus an LVM metadata backup on the host. Only
the new disk's extents are added to the existing root LV, then ext4 is expanded
online. There is no reboot, shrink, migration, or formatting of the original disk.

The resulting root volume spans both disks. Keep both attached; deleting this
chart or its completed Job does not undo the storage expansion. Host records are
in `/var/lib/ci-runner-storage`. The Job has no Kubernetes token or RBAC access.
