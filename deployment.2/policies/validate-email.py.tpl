import re


# Validates and stores ieee-id into user attributes
if '${field_name}' not in context.get('prompt_data', {}):
    return False

if re.search('${email_domain_regex}', context['prompt_data']['${field_name}']) is None:
    ak_message("Invalid email. it must match with ${email_domain_regex}")
    return False

if 'attributes' not in context['prompt_data']:
    context['prompt_data']['attributes'] = {}

context['prompt_data']['attributes']['${field_name}'] = context['prompt_data']['${field_name}']
return True