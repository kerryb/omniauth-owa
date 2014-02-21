# OmniAuth-OWA

## About

This is an [OmiAuth](https://github.com/intridea/omniauth) strategy for
authenticating against an Outlook Web Access server. Might be handy if you want
to allow people to authenticate against your company's LDAP credentials but the
only way they're exposed on the Internet is through webmail login.

Currently barely more than a proof of concept, only tested against one specific
OWA server, and certainly not production quality!

## Installation

    gem install omniauth-owa

Or if you're using bundler, put it in your gemfile:

    gem "omniauth-owa"

## Usage

Rails example:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :owa, base_url: "https://mail.example.com", form: SessionsController.action(:new)
    end

If you override the form (as in the example above), it should post to
`/auth/owa/callback` with `uid` and `password` parameters.

The parameters returned in the authentication hash are:

* uid
* info.name
* info.first_name
* info.last_name
* info.email

## Licence

The MIT License (MIT)

Copyright (c) 2014 Kerry Buckley

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
