
variable "es_domain" {
    description = "ElasticSearch domain, the cluster nodes will be deployed here"
}

variable "es_subnets" {
    type = "list"
    description = " List of VPC  Subnet IDs to create ElasticSearch Endpoints"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Create a Security Group to restrict network access to ElasticSearch cluster
resource "aws_security_group" "es_sg" {
    name = "${var.es_domain}-sg"
    description = "Allow inbound traffic to Elasticsearch from VPC CIDR"
    vpc_id = "${var.vpc_name}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "${var.cidr_block"
        ]
    }
}

# Create the elasticsearch domain that will define the elasticsearch cluster
resource "aws_elasticsearch_domain" "es" {
    domain_name = "${var.es_domain}"
    elasticsearch_version = "7.4"

    cluster_config {
        instance_type = "r4.large.elasticsearch"
    }

    vpc_options {
        subnet_ids = "${var.es_subnets}"
        security_group_ids = [
            "${aws_security_group.es_sg.id}"
        ]
    }

    ebs_options {
        ebs_enabled = true
        volume_size = 10
    }

    access_policies = << CONFIG
        {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "es:*",
                "Principal": "*",
                "Effect": "Allow",
                "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
            }
        ]
        }
    CONFIG

    snapshot_options {
        automated_snapshot_start_hour = 23
    }

    tags {
        Domain = "${var.es_domain}"
    }
}

output "ElasticSearch Endpoint" {
  value = "${aws_elasticsearch_domain.es.endpoint}"
}

output "ElasticSearch Kibana Endpoint" {
  value = "${aws_elasticsearch_domain.es.kibana_endpoint}"
}
