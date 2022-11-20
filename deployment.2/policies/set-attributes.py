no_save = ['attributes', 'component']

if 'prompt_data' not in context:
    context['prompt_data'] = {}

if 'attributes' not in context['prompt_data']:
    context['prompt_data']['attributes'] = {}

for key in context['prompt_data'].keys():
    if key not in no_save and f"__no_save_{key}" not in context['prompt_data'] and not key.startswith("__no_save_"):
        context['prompt_data']['attributes'][key] = context['prompt_data'][key]

return True
