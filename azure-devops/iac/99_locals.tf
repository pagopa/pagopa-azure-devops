locals {
  definitions = [
    {
      name : "next-core-secrets",
      envs : ["d", "u", "p"],
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
    {
      name : "checkout",
      envs : ["d", "u", "p"],
      kv_name : "",
      rg_name : "",
      code_review : true,
      deploy : true,
      pipeline_prefix : "checkout",
      pipeline_path : ".devops",
      repository : {
        yml_prefix_name : "checkout"
      }
    },
  ]

  definitions_variables = {}
}
