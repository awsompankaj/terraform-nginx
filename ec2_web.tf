resource "aws_instance" "anisble" {      // using resource aws_instance to create ec2 
  ami = "ami-0b37e9efc396e4c38"          // using ubuntu
    instance_type = "t2.micro"
    security_groups = ["default"]   //existing security group
    key_name = "practical"          // already created private key   

  tags  {
      Name = "ansible provisioner"
  }
provisioner "remote-exec" {         //in case python not installed on remote machine
      inline = [
      "sudo apt-get install python -y"
        ]
connection {
type = "ssh"
user = "ubuntu"
host = "${aws_instance.anisble.public_ip}"
private_key = "${file("./practical.pem")}"      //local path for private file
}
}
provisioner "local-exec" {
    command = "echo ${aws_instance.anisble.public_ip} > inventory" //create local  inventory file

}
provisioner "local-exec" {
  command = "sleep 120; ANSIBLE_KEY_HOST_CHECKING=false ansible-playbook -s -v -u ubuntu --private-key=./practical.pem  nginx.yml -i inventory" //ansible play to install nginx and start nginx service
}

}
