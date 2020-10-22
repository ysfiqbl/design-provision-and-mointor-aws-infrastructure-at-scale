provider "aws" {
	region  = "us-east-1"
	profile = "443t"
}


resource "aws_instance" "udacity-t2" {
	count         = 4
	ami           = "ami-0817d428a6fb68645"
	instance_type = "t2.micro"
	key_name      = "yusuf-443t"
	subnet_id     = "subnet-0e23681380b642975"
	
	tags = {
		Name = "Udacity T2"
	}

}

resource "aws_instance" "udacity-t4" {
	count         = 2
	ami           = "ami-0817d428a6fb68645"
	instance_type = "m4.large"
	key_name      = "yusuf-443t"
	subnet_id     = "subnet-0e23681380b642975"
	
	tags = {
		Name = "Udacity T4"
	}

}
