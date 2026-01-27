after 2s [id=sg-0ead4b0c58bc5e9df]
╷
│ Error: importing EC2 Key Pair (prueba-qa): operation error EC2: ImportKeyPair, https response error StatusCode: 400, RequestID: 71180fc3-03f2-4eaa-a923-573edfe59b4e, api error InvalidKeyPair.Duplicate: The keypair already exists
│ 
│   with aws_key_pair.shared,
│   on kepairs.tf line 6, in resource "aws_key_pair" "shared":
│    6: resource "aws_key_pair" "shared" {
│ 
╵
Error: Terraform exited with code 1.
Error: Process completed with exit code 1.
0s
0s
0s
