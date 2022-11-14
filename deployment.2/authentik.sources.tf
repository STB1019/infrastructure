
resource "authentik_source_oauth" "github-source" {
  name                = "github"
  slug                = "github"
  
  authentication_flow = authentik_flow.sso-authentication-flow.uuid
  enrollment_flow     = authentik_flow.sso-enrollment-flow.uuid

  provider_type   = "github"
  consumer_key    = var.gh_client_id
  consumer_secret = var.gh_secret
  user_path_template = "users/stb1019"
  additional_scopes = "read:user read:org"
}