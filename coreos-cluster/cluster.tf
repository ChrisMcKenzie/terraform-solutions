provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "coreos-machine" {
  image = "coreos-alpha"
  count = "${var.count}"
  name = "${var.group}-${count.index}"
  size = "${var.size}"
  region = "${var.region}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  user_data = "${template_file.config.rendered}"

  provisioner "file" {
    source = "fleet-files"
    destination = "/home/core/"
    connection {
      user = "core"
    }
  }

  provisioner "remote-exec" {
      connection {
        user = "core"
      }
      inline = [
        "sleep 10",
        "cd /home/core/fleet-files/",
        "fleetctl load swarm.service",
        "fleetctl start swarm.service",
        "fleetctl load swarm-manager@.service",
        "fleetctl start swarm-manager@{1..3}.service",
      ]
  }
}


