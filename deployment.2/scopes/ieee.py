return {
    "ieee-id": request.user.attributes.get('ieee-id', None),
    "ieee-email": request.user.attributes.get('ieee-email', None),
}