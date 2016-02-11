#cloud-config

coreos:
  etcd2:
    # generate a new token for each unique cluster from https://discovery.etcd.io/new?size=3
    discovery: ${discovery_url}
    # multi-region and multi-cloud deployments need to use $public_ipv4
    advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001
    initial-advertise-peer-urls: http://$private_ipv4:2380
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380
  fleet:
    public-ip: "$private_ipv4"
    metadata: "region=${region}, group=${group}"
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
    - name: docker.service
      command: start

write_files:
  - path: "/etc/motd"
    permissions: "0644"
    owner: "root"
    content: |
      Good news, everyone!
