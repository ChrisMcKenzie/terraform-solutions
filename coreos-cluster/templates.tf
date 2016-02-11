resource "template_file" "config" {
  template = "${file("user_data.tpl")}"
  vars {
    region = "${var.region}"
    group = "${var.group}"
    discovery_url = "${var.discovery_url}"
  }
}
