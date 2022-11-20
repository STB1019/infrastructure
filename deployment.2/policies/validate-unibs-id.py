# Validates and stores unibs-id into user attributes
if 'unibs-id' not in context.get('prompt_data', {}):
    return False

if not context['prompt_data']['unibs-id'].isnumeric() or len(context['prompt_data']['unibs-id']) != 6:
    ak_message("Invalid unibs id. it must be numeric and long 6 characters")
    return False

#if 'attributes' not in context['prompt_data']:
#    context['prompt_data']['attributes'] = {}
#
#context['prompt_data']['attributes']['unibs-id'] = context['prompt_data']['unibs-id']
return True