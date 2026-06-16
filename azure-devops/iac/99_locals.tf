locals {
  definitions = [
    {
      name : "next-core-secrets",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      region : "weu"
      code_review : true,
      deploy : false,
      pipeline_prefix : "next-core-secrets",
      pipeline_path : "next-core-infra",
      repository : {
        yml_prefix_name : "next-core-secrets"
      }
    },
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
    },
    {
      name : "client-certs",
      envs : ["d", "u", "p"],
      region : "weu"
      code_review : true,
      deploy : true,
      pipeline_prefix : "client-certs",
      pipeline_path : "client-certificates-infra",
      repository : {
        yml_prefix_name : "client-certs"
        branch_name : "refs/heads/main"
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
    }
  ]

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
}
