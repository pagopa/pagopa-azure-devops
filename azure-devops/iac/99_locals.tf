locals {
  definitions = concat(local.infra_core_definitions, [
    {
      name : "checkout",
      envs : ["d", "u", "p"],
      kv_name : "pagopa-%s-checkout-kv",
      rg_name : "pagopa-%s-checkout-sec-rg",
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "checkout",
      pipeline_path : "checkout-infra",
      repository : {
        yml_prefix_name : "checkout"
      }
    },
    {
      name : "cruscotto",
      envs : ["d"],
      kv_name : "pagopa-%s-itn-crusc8-kv",
      rg_name : "pagopa-%s-itn-crusc8-sec-rg",
      region : "itn"
      code_review : true,
      deploy : true,
      pipeline_prefix : "cruscotto",
      pipeline_path : "cruscotto-infra",
      repository : {
        yml_prefix_name : "cruscotto"
      }
    }
  ])


  definitions_variables = {}

  generic_pipelines = {
    "gh-runner-daily-cleanup" : {
      pipeline_prefix : "gh-runner-daily-cleanup",
      pipeline_path : "gh-runner-cleanup",
      repository : {
        yml_file_name : "gh-runner-cleanup.yml"
      }
      schedules : {
        days_to_build : ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        schedule_only_with_changes : false,
        start_hours : 18,
        start_minutes : 0,
        time_zone : "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
        branch_filter : {
          include : ["refs/heads/main"],
          exclude : []
        }
      }
    },
    "disaster-recovery" : {
      pipeline_prefix : "disaster-recovery",
      pipeline_path : "disaster-recovery",
      repository : {
        yml_file_name : "disaster-recovery.yml"
      }
    },
    "performance-test-setup" : {
      pipeline_prefix : "performance-test-setup",
      pipeline_path : "performance-test-setup",
      repository : {
        yml_file_name : "performance-test-setup.yml"
      }
      schedules : {
        days_to_build : ["Fri"],
        schedule_only_with_changes : false,
        start_hours : 19,
        start_minutes : 0,
        time_zone : "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
        branch_filter : {
          include : ["refs/heads/main"],
          exclude : []
        }
      }
    },
    "metabase" : {
      pipeline_prefix : "metabase-connection",
      pipeline_path : "database",
      repository : {
        yml_file_name : "db-metabase-pipelines.yml"
      }
    },
    "liquibase-addon" : {
      pipeline_prefix : "liquibase-addon",
      pipeline_path : "database",
      repository : {
        yml_file_name : "db-addon-migration-pipelines.yml"
      }
    }

    // FdR-Fase3 Archive DB pipeline
    "fdr-fase3-archive-db-schema-pipelines" : {
      pipeline_prefix : "fdr3-archive",
      pipeline_path : "fdr3-infrastructure",
      repository : {
        organization : "pagopa"
        name : "pagopa-fdr"
        branch_name : "refs/heads/main"
        pipelines_path : ".devops"
        yml_file_name : "fdr-fase3-archive-db-schema-pipelines.yml"
      }
    }
  }

  infra_core_definitions = [
  {
      name : "audit-logs",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "audit-logs",
      pipeline_path : "pagopa-infra-core\\audit-logs",
      repository : {
        yml_prefix_name = "audit-logs"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "client-certs",
      envs : ["d", "u", "p"],
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "client-certs",
      pipeline_path : "pagopa-infra-core\\client-certs",
      repository : {
        yml_prefix_name : "client-certs"
        branch_name : "refs/heads/main"
        name           = "pagopa-infra-core"
      }
      schedules = {
        days_to_build              = ["Mon"]
        schedule_only_with_changes = false
        start_hours                = 3
        start_minutes              = 0
        time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
        branch_filter = {
          include = ["main"]
          exclude = []
        }
      }
    },
    {
      name : "cloudo",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "itn"
      code_review : true,
      deploy : true,
      pipeline_prefix : "cloudo",
      pipeline_path : "pagopa-infra-core\\cloudo",
      repository : {
        yml_prefix_name = "cloudo"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "core-itn",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "itn"
      code_review : true,
      deploy : true,
      pipeline_prefix : "core-itn",
      pipeline_path : "pagopa-infra-core\\core-itn",
      repository : {
        yml_prefix_name = "core-itn"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "db-security",
      envs : ["d", "p"],
      kv_name : "",
      rg_name : "",
      region : "itn"
      code_review : true,
      deploy : true,
      pipeline_prefix : "db-security",
      pipeline_path : "pagopa-infra-core\\db-security",
      repository : {
        yml_prefix_name = "db-security"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "db-security-configuration",
      envs : ["d", "p"],
      kv_name : "",
      rg_name : "",
      region : "itn"
      code_review : true,
      deploy : true,
      pipeline_prefix : "db-security-configuration",
      pipeline_path : "pagopa-infra-core\\db-security",
      repository : {
        yml_prefix_name = "db-security-configuration"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "grafana-monitoring",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "grafana-monitoring",
      pipeline_path : "pagopa-infra-core\\grafana-monitoring",
      repository : {
        yml_prefix_name = "grafana-monitoring"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "network",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "network",
      pipeline_path : "pagopa-infra-core\\network",
      repository : {
        yml_prefix_name = "network"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "next-aks",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "next-aks",
      pipeline_path : "pagopa-infra-core\\aks",
      repository : {
        yml_prefix_name = "next-aks"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "next-core",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "next-core",
      pipeline_path : "pagopa-infra-core\\next-core",
      repository : {
        yml_prefix_name = "next-core"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "packer-image",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : false,
      deploy : true,
      pipeline_prefix : "packer",
      pipeline_path : "pagopa-infra-core\\packer-image",
      repository : {
        yml_prefix_name = "packer-image"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "release-notes-agent",
      envs : ["d"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : false,
      deploy : true,
      pipeline_prefix : "release-notes-agent",
      pipeline_path : "pagopa-infra-core\\release-notes-agent",
      repository : {
        yml_prefix_name = "release-notes-agent"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "synthetic-monitoring",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : false,
      deploy : true,
      pipeline_prefix : "synthetic-monitoring",
      pipeline_path : "pagopa-infra-core\\synthetic-monitoring",
      repository : {
        yml_prefix_name = "synthetic-monitoring"
        name           = "pagopa-infra-core"
      }
    },
    {
      name : "tf-audit",
      envs : ["p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : false,
      deploy : true,
      pipeline_prefix : "tf-audit",
      pipeline_path : "pagopa-infra-core\\tf-audit",
      repository : {
        yml_prefix_name = "tf-audit"
        name           = "pagopa-infra-core"
      }
    }
  ]
}
