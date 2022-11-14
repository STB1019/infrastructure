resource "authentik_flow" "enrollment-flow" {
  name        = "Iscriviti a STB1019"
  title       = "Iscriviti in STB1019"
  slug        = "stb1019-enrollment-flow"
  designation = "enrollment"
  layout      = "sidebar_left"
  background  = "/bg.jpg"
}

