data "terraform_remote_state" "remote_state" {
  backend = "local"
  config = {
    path = "../1-infra/terraform.tfstate"
  }
}

provider "gitlab" {
  token    = data.terraform_remote_state.remote_state.outputs.gitlab_root_user_personal_access_token
  base_url = "${data.terraform_remote_state.remote_state.outputs.gitlab_endpoint}/api/v4/"
}

provider "jenkins" {
  server_url = data.terraform_remote_state.remote_state.outputs.jenkins_endpoint
  username   = "root"
  password   = data.terraform_remote_state.remote_state.outputs.gitlab_root_user_personal_access_token
}

module "devsecops-sandbox-config" {
  source            = "git::https://github.com/saic-oss/terraform-devsecops-sandbox-config.git?ref=tags/0.5.3"
  gitlab_user_count = var.gitlab_user_count
  gitlab_group_name = var.gitlab_group_name
  gitlab_endpoint   = data.terraform_remote_state.remote_state.outputs.gitlab_endpoint
  jenkins_endpoint  = data.terraform_remote_state.remote_state.outputs.jenkins_endpoint
}
