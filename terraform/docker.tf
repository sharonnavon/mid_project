data "template_file" "docker_install" {
  template = "${file("${path.module}/templates/docker.sh.tpl")}"
}

resource "aws_instance" "docker_server" {
  count = "${var.docker_servers}"
  associate_public_ip_address = true
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_default.id}"]
  key_name = "${var.key_name}"
  tags {
    Name = "docker-server"
  }
  user_data = "${element(data.template_file.docker_install)}"
}
