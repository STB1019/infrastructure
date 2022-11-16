from authentik.stages.authenticator_webauthn.models import WebAuthnDevice
from authentik.stages.authenticator_duo.models import DuoDevice

has_duo = DuoDevice.objects.filter(user=request.context['pending_user'], confirmed=True).exists()
has_webauthn = WebAuthnDevice.objects.filter(user=request.context['pending_user'], confirmed=True).exists()

return not has_duo and not has_webauthn