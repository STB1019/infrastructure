if request.user is None or request.user.name == "AnonymousUser":
    return False

return \
    not ak_is_group_member(request.user, name="membership") \
    and not ak_is_group_member(request.user, name="financial") \
    and not ak_is_group_member(request.user, name="publicity")