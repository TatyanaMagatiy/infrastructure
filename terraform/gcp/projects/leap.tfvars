prefix     = "leap"
project_id = "leap-pangeo"
# core_node_machine_type is set to n2-highmem-4 instead of n2-highmem-2 because
# prometheus requires more memory than a n2-highmem-2 can provide.
core_node_machine_type = "n2-highmem-4"

k8s_versions = {
  min_master_version : "1.27.4-gke.900",
  core_nodes_version : "1.27.4-gke.900",
  notebook_nodes_version : "1.27.4-gke.900",
  dask_nodes_version : "1.27.4-gke.900",
}

# FIXME: Remove temp_opt_out_node_purpose_label when a node upgrade can be
#        done. See https://github.com/2i2c-org/infrastructure/issues/3405.
temp_opt_out_node_purpose_label_core_nodes = true

# GPUs not available in us-central1-b
zone             = "us-central1-c"
region           = "us-central1"
regional_cluster = true

# Multi-tenant cluster, network policy is required to enforce separation between hubs
enable_network_policy = true

# Setup a filestore for in-cluster NFS
enable_filestore      = true
filestore_capacity_gb = 2048

user_buckets = {
  "scratch-staging" : {
    "delete_after" : 7,
    "extra_admin_members" : [],
    "usage_logs" : true,
  },
  "scratch" : {
    "delete_after" : 7,
    "extra_admin_members" : [],
    "usage_logs" : true,
  }
  # For https://github.com/2i2c-org/infrastructure/issues/1230#issuecomment-1278183441
  "persistent" : {
    "delete_after" : null,
    "extra_admin_members" : ["group:leap-persistent-bucket-writers@googlegroups.com"],
    "usage_logs" : true,
  },
  "persistent-staging" : {
    "delete_after" : null,
    "extra_admin_members" : ["group:leap-persistent-bucket-writers@googlegroups.com"],
    "usage_logs" : true,
  }
  # For https://github.com/2i2c-org/infrastructure/issues/1230#issuecomment-1278183441
  "persistent-ro" : {
    "delete_after" : null,
    "extra_admin_members" : ["group:leap-persistent-bucket-writers@googlegroups.com"],
    "usage_logs" : true,
  },
  "persistent-ro-staging" : {
    "delete_after" : null,
    "extra_admin_members" : ["group:leap-persistent-bucket-writers@googlegroups.com"],
    "usage_logs" : true,
  }
}

hub_cloud_permissions = {
  "staging" : {
    requestor_pays : true,
    bucket_admin_access : ["scratch-staging", "persistent-staging"],
    bucket_readonly_access : ["persistent-ro-staging"],
    hub_namespace : "staging"
  },
  "prod" : {
    requestor_pays : true,
    bucket_admin_access : ["scratch", "persistent"],
    bucket_readonly_access : ["persistent-ro"],
    hub_namespace : "prod"
  }
}

# Setup notebook node pools
notebook_nodes = {
  # FIXME: Remove temp_opt_out_node_purpose_label when a node upgrade can be
  #        done. See https://github.com/2i2c-org/infrastructure/issues/3405.
  "n2-highmem-4" : {
    min : 0,
    max : 100,
    machine_type : "n2-highmem-4",
    temp_opt_out_node_purpose_label : true,
  },
  # FIXME: Rename this to "n2-highmem-16" when given the chance and no such nodes are running
  # FIXME: Remove node pool specific node_version pin when given the chance and no such nodes are running
  # FIXME: Remove temp_opt_out_node_purpose_label when a node upgrade can be
  #        done. See https://github.com/2i2c-org/infrastructure/issues/3405.
  "medium" : {
    # A minimum of one is configured for LEAP to ensure quick startups at all
    # time. Cost is not a greater concern than optimizing startup times.
    min : 1,
    max : 100,
    machine_type : "n2-highmem-16",
    node_version : "1.25.6-gke.1000",
    temp_opt_out_node_purpose_label : true
  },
  # FIXME: Remove temp_opt_out_node_purpose_label when a node upgrade can be
  #        done. See https://github.com/2i2c-org/infrastructure/issues/3405.
  "n2-highmem-64" : {
    min : 0,
    max : 100,
    machine_type : "n2-highmem-64"
    temp_opt_out_node_purpose_label : true
  }
  # FIXME: Remove node pool specific node_version pin when given the chance and no such nodes are running
  # FIXME: Remove temp_opt_out_node_purpose_label when a node upgrade can be
  #        done. See https://github.com/2i2c-org/infrastructure/issues/3405.
  "gpu-t4" : {
    min : 0,
    max : 100,
    machine_type : "n1-standard-8",
    node_version : "1.25.6-gke.1000",
    temp_opt_out_node_purpose_label : true
    gpu : {
      enabled : true,
      type : "nvidia-tesla-t4",
      count : 1
    },
    zones : [
      # Get GPUs wherever they are available, as sometimes a single
      # zone might be out of GPUs.
      "us-central1-a",
      "us-central1-b",
      "us-central1-c",
      "us-central1-f"
    ]
  },
}

# Setup a single node pool for dask workers.
#
# A not yet fully established policy is being developed about using a single
# node pool, see https://github.com/2i2c-org/infrastructure/issues/2687.
#
dask_nodes = {
  # FIXME: Remove temp_opt_out_node_purpose_label when a node upgrade can be
  #        done. See https://github.com/2i2c-org/infrastructure/issues/3405.
  "n2-highmem-16" : {
    min : 0,
    max : 200,
    # Disable preemptive nodes for dask so we can remove possible complications
    # on why some dask computations are dying off.
    # See https://github.com/2i2c-org/infrastructure/issues/2396
    preemptible : false,
    machine_type : "n2-highmem-16"
    temp_opt_out_node_purpose_label : true
  },
}
