from authentik.core.models import Group

if request.user is None or request.user.name == "AnonymousUser":
    return False

if \
    ak_is_group_member(request.user, name="membership") \
    or ak_is_group_member(request.user, name="financial") \
    or ak_is_group_member(request.user, name="publicity"):
    return False

if 'committee' not in context.get('prompt_data', {}):
    return False

group, _ = Group.objects.get_or_create(name=context['prompt_data']['committee'])
request.context["flow_plan"].context["groups"] = [group]
request.context["flow_plan"].context["pending_user"] = request.user
return True