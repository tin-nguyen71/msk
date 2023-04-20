output "cluster_domain" {
  value       = data.aws_msk_broker_nodes.msk_broker_nodes[0].node_info_list[*].endpoints
  description = "Cluster domain"
}

output "cluster_arn" {
  value       = try(aws_msk_cluster.kafka_cluster[0].arn, "")
  description = "Cluster arn"
}
