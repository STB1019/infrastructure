if 'committee' not in context.get('prompt_data', {}):
    return False

if context['prompt_data']['committee'] not in ['membership', 'financial', 'publicity']:
    ak_message("committee must be one of ['membership', 'financial', 'publicity']")
    return False

return True