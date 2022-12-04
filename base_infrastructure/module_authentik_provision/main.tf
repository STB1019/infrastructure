terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2022.10.0"
    }
  }
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}