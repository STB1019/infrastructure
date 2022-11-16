token = "${ssh_token}"

ssh_allowed = {
    "membership": [""],
    "publicity": ["ieeesb@ieeesb.unibs.it"],
    "financial": [""],
    "executive": ["webmaster@ieee.elux.ing.unibs.it"]
}

_principals = [ssh_allowed[k] if ak_is_group_member(request.user, name=k) else [] for k in ssh_allowed.keys()]
principals = ["default"]
for p in _principals:
    principals.extend(p)

res = requests.post("https://${vault_ip}:8233/v1/ssh/issue/${ssh_client_ep}", json={
    "key_type": "ec",
    "key_bits": 521, 
    "ttl": "4h",
    "valid_principals": ",".join(principals)
}, headers={
    "X-Vault-Token": token 
}, verify=False)

if res.status_code != 200:
    return {
        "ssh": False
    }
 
data = res.json()

return {
    "ssh": {
        "private": data['data']['private_key'],
        "public": data['data']['signed_key'],
        "serial": data['data']['serial_number'],
        "principals": principals
    }
}
