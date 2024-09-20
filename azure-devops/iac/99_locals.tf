locals {
  definitions = [
    {
      name : "next-core-secrets",
      envs : ["d", "u"],
      kv_name : "",
      rg_name : "",
      code_review : true,
      deploy : false,
      pipeline_prefix : "next-core-secrets",
      pipeline_path : "next-core-infra",
      repository : {
        yml_prefix_name : "next-core-secrets"
      }
    },
  ]

  domain_variables = {}
}
