# Validates and stores ieee-id into user attributes
if 'ieee-id' not in context.get('prompt_data', {}):
    return False

if not context['prompt_data']['ieee-id'].isnumeric() or len(context['prompt_data']['ieee-id']) != 8:
    ak_message("Invalid ieee id. it must be numeric and long 8 characters")
    return False

#if 'attributes' not in context['prompt_data']:
#    context['prompt_data']['attributes'] = {}
#
#context['prompt_data']['attributes']['ieee-id'] = context['prompt_data']['ieee-id']
return True