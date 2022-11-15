# Validates and stores ieee-id into user attributes
if '${attribute}' not in context.get('prompt_data', {}):
    ak_message(f"Required field ${attribute}")
    return False

if 'attributes' not in context['prompt_data']:
    context['prompt_data']['attributes'] = {}

context['prompt_data']['attributes']['${attribute}'] = context['prompt_data']['${attribute}']
return True