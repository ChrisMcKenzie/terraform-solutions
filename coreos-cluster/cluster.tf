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
  ssh_keys = [20457]
  user_data = "${template_file.config.rendered}"
}
