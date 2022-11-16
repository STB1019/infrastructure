if 'prompt_data' not in context:
    return False

if 'attributes' not in context['prompt_data']:
    context['prompt_data']['attributes'] = {}

context['prompt_data']['attributes']['has_password'] = True
    
return True