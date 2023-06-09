resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "main_key_pair" {
  key_name   = "main-key-1"
  public_key = tls_private_key.rsa.public_key_openssh
  depends_on = [aws_security_group.demosg]
}

output "private_key_pem" {
  value = tls_private_key.rsa.private_key_pem
  sensitive = true
}

resource "null_resource" "copy" {
  provisioner "local-exec" {
  command = <<-EOT
    echo "${tls_private_key.rsa.private_key_pem}" > main-key-1.pem
    chmod 400 main-key-1.pem
  EOT
 }
  depends_on = [aws_key_pair.main_key_pair]
}

  
