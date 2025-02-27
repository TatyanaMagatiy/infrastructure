prefix     = "m2lines"
project_id = "m2lines-hub"

# GPUs not available in us-central1-b
zone             = "us-central1-c"
region           = "us-central1"
regional_cluster = true

k8s_versions = {
  min_master_version : "1.27.4-gke.900",
  core_nodes_version : "1.27.4-gke.900",
  notebook_nodes_version : "1.27.4-gke.900",
  dask_nodes_version : "1.27.4-gke.900",
}

core_node_machine_type = "n2-highmem-4"
enable_network_policy  = true


# Setup a filestore for in-cluster NFS
enable_filestore      = true
filestore_capacity_gb = 2048

user_buckets = {
  "scratch-staging" : {
    "delete_after" : 7
  },
  "scratch" : {
    "delete_after" : 7
  },
  # For https://2i2c.freshdesk.com/a/tickets/218
  "persistent" : {
    "delete_after" : null,
    "extra_admin_members" : ["group:m2lines-persistent-bucket-writers@googlegroups.com"]
  },
  "persistent-staging" : {
    "delete_after" : null,
    "extra_admin_members" : ["group:m2lines-persistent-bucket-writers@googlegroups.com"]
  },
  "public-persistent" : {
    "delete_after" : null,
    "extra_admin_members" : ["group:m2lines-persistent-bucket-writers@googlegroups.com"],
    "public_access" : true
  },

}

# Setup notebook node pools
notebook_nodes = {
  "n2-highmem-4" : {
    min : 0,
    max : 100,
    machine_type : "n2-highmem-4",
  },
  "n2-highmem-16" : {
    min : 0,
    max : 100,
    machine_type : "n2-highmem-16",
  },
  "n2-highmem-64" : {
    min : 0,
    max : 100,
    machine_type : "n2-highmem-64",
  },
  "small" : {
    min : 0,
    max : 100,
    machine_type : "n1-standard-2",
  },
  "medium" : {
    min : 0,
    max : 100,
    machine_type : "n1-standard-4",
  },
  "large" : {
    min : 0,
    max : 100,
    machine_type : "n1-standard-8",
  },
  "huge" : {
    min : 0,
    max : 100,
    machine_type : "n1-standard-16",
  },
  "gpu-t4" : {
    min : 0,
    max : 100,
    machine_type : "n1-standard-8",
    gpu : {
      enabled : true,
      type : "nvidia-tesla-t4",
      count : 1
    }
  }
}

# Setup a single node pool for dask workers.
#
# A not yet fully established policy is being developed about using a single
# node pool, see https://github.com/2i2c-org/infrastructure/issues/2687.
#
dask_nodes = {
  "worker" : {
    min : 0,
    max : 100,
    machine_type : "n2-highmem-16",
  }
}

hub_cloud_permissions = {
  "staging" : {
    requestor_pays : true,
    bucket_admin_access : ["scratch-staging", "persistent-staging"],
    hub_namespace : "staging"
  },
  "prod" : {
    requestor_pays : true,
    bucket_admin_access : ["scratch", "persistent", "public-persistent"],
    hub_namespace : "prod"
  },
}
