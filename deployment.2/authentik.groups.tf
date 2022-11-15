resource authentik_group executive {
  name         = "executive"
  users        = []
  is_superuser = true
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource authentik_group member {
  name         = "member"
  is_superuser = false
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource authentik_group publicity {
  name         = "publicity"
  is_superuser = false
  parent = authentik_group.member.id
}

resource authentik_group membership {
  name         = "membership"
  is_superuser = false
  parent = authentik_group.member.id
}

resource authentik_group financial {
  name         = "financial"
  is_superuser = false
  parent = authentik_group.member.id
}
