terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2022.10.0"
    }
  }
}

resource "authentik_group" "member" {
  name         = "member"
  is_superuser = false
}

resource "authentik_group" "membership" {
  name         = "membership"
  is_superuser = false
  parent       = authentik_group.member.id
}

resource "authentik_group" "financial" {
  name         = "financial"
  is_superuser = false
  parent       = authentik_group.member.id
}

resource "authentik_group" "publicity" {
  name         = "publicity"
  is_superuser = false
  parent       = authentik_group.member.id
}

resource "authentik_group" "executive" {
  name         = "executive"
  is_superuser = true
  parent       = authentik_group.member.id
}

