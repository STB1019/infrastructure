return {
    "kube": [group.name for group in request.user.ak_groups.all()]
}