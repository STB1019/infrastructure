from authentik.core.models import Group
group, _ = Group.objects.get_or_create(name=context['prompt_data']['committee'])
request.context["flow_plan"].context["groups"] = [group]
request.context["flow_plan"].context["pending_user"] = request.user
return True