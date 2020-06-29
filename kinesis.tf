resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "tf-${var.name}-kinesis-stream"
  shard_count      = "${var.shard_count}"
  retention_period = "${var.retention_period}"

  shard_level_metrics = "${var.shard_level_metrics}"

  tags = {
    Name = "kns-${var.name}"
    owner = "${var.name}"
  }
}