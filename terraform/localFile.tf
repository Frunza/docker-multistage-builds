resource "local_file" "someLocalFile" {
  content  = <<EOF
myContent:
  - something: 'aaa'
  - something2: ${timestamp()}'
EOF
  filename = "myLocalFile.yml"
}
