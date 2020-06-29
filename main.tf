provider "aws" {
    version = "~> 2.0"
    region = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

resource "aws_vpc" "vpc_kintel" {
    cidr_block = "${var.cidr_block}"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags {
        Name = "${var.vpc_name}"
        Environment = "${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "igw_kintel" {
    vpc_id = "${aws_vpc.vpc_kintel.id}"
    tags = {
        Name = "igw_kintel"
    }
}

########################################################################################################
# Create Public Subnet  in each Availability Zone. 
########################################################################################################

resource "aws_subnet" "subnet_public" {
  count                   = "${length(data.aws_availability_zones.availability_zones.names)-1}"
  vpc_id                  = "${aws_vpc.vpc_kintel.id}"
  availability_zone       = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
  cidr_block              = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+1)}"
  map_public_ip_on_launch = "True"

 tags {
    Name = "subnet_public-${count.index}"
  }
}


#######################################################################################################
# Create Route Tables
########################################################################################################
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc_kintel.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
    tags = {
    Name = "Public Route"
  }
}

########################################################################################################
# Route Tables Association
########################################################################################################

resource "aws_route_table_association" "public_subnet" {
    count             = "${length(data.aws_availability_zones.availability_zones.names)-1}"
    subnet_id         = "${element(aws_subnet.subnet_public.*.id, count.index)}"
    route_table_id    = "${aws_route_table.public_route.id}"

}
