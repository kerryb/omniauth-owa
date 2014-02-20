[OmiAuth](https://github.com/intridea/omniauth) strategy for authenticating
against an Outlook Web Access server. Might be handy if you want to allow
people to authenticate against your company's LDAP credentials but the only way
they're exposed on the Internet is through webmail login.

Currently barely more than a proof of concept, only tested against one specific
OWA server, and certainly not production quality!

## Usage

Rails example:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :owa, base_url: "https://mail.example.com", form: SessionsController.action(:new)
    end

If you override the form (as in the example above), it should post to
`/auth/owa/callback` with `uid` and `password` parameters.
