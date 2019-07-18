resource "aws_instance" "anisble" {
  ami = "ami-0b37e9efc396e4c38"
    instance_type = "t2.micro"
    security_groups = ["default"]
    key_name = "practical"

  tags  {
      Name = "ansible provisioner"
  }
provisioner "remote-exec" {
      inline = [
      "sudo apt-get install python -y"
        ]
connection {
type = "ssh"
user = "ubuntu"
host = "${aws_instance.anisble.public_ip}"
private_key = "${file("./practical.pem")}"
}
}
provisioner "local-exec" {
    command = "echo ${aws_instance.anisble.public_ip} > inventory"

}
provisioner "local-exec" {
  command = "sleep 120; ANSIBLE_KEY_HOST_CHECKING=false ansible-playbook -s -v -u ubuntu --private-key=./practical.pem  nginx.yml -i inventory"

}

}
