require "rack/test"
require "nokogiri"
require "omniauth/test"
require "webmock/rspec"

require "omniauth/strategies/owa"
require "omniauth/strategies/owa"

describe OmniAuth::Strategies::OWA do
  include Rack::Test::Methods
  OmniAuth.config.logger = Logger.new "/dev/null"

  let(:app) do
    Rack::Builder.new do |b|
      b.use Rack::Session::Cookie, :secret => "secret"
      b.use OmniAuth::Strategies::OWA, base_url: "https://mail.example.com"
      b.run ->(_env) { [200, {}, [""]] }
    end.to_app
  end

  it "camelizes itself to 'OWA'" do
    expect(OmniAuth::Utils.camelize"owa").to eq "OWA"
  end

  describe "request phase" do
    let(:html) { Nokogiri::HTML last_response.body }

    before { get "/auth/owa" }

    it "displays a form with the callback path" do
      expect(html.xpath("//form/@action").text).to eq "/auth/owa/callback"
    end

    it "displays a uid field" do
      expect(html.xpath("//form/input[@type='text'][@name='uid']")).not_to be_empty
    end

    it "displays a password field" do
      expect(html.xpath("//form/input[@type='password'][@name='password']")).not_to be_empty
    end

    it "displays a 'Log in' button" do
      expect(html.xpath("//form/button[@type='submit']/text()").text).to eq "Log in"
    end
  end

  describe "callback phase" do
    let(:auth_hash) { last_request.env["omniauth.auth"] }

    context "when authentication succeeds" do
      before do
        stub_request(:get, "https://fred:secret@mail.example.com/owa/?ae=Dialog&t=AddressBook&ctx=1&sch=fred").
          to_return body: <<-EOF
          Blah blah
          <h1><a href=\"#\" id=\"an=id\" onClick=\"return onClkRcpt(this, 1);\">Fred Bloggs</a></h1>
          blah
        EOF

        stub_request(:get, "https://fred:secret@mail.example.com/owa/?ae=Item&t=AD.RecipientType.User&id=an%3Did").
          to_return body: <<-EOF
          Blah blah
          <tr><td class="lbl lp" nowrap>First name</td><td class="txvl">Fred</td></tr>
          <tr><td class="lbl lp" nowrap>Last name</td><td class="txvl">Bloggs</td></tr>
          <tr><td class="lbl lp" nowrap>E-mail</td><td class="txvl">fred.bloggs@example.com</td></tr>
          blah
        EOF

        post "/auth/owa/callback", uid: "fred", password: "secret"
      end

      it "sets the uid to the value submitted" do
        expect(auth_hash.uid).to eq "fred"
      end

      it "sets the name in the auth hash" do
        expect(auth_hash.info.name).to eq("Fred Bloggs")
      end

      it "sets the first name in the auth hash" do
        expect(auth_hash.info.first_name).to eq("Fred")
      end

      it "sets the last name in the auth hash" do
        expect(auth_hash.info.last_name).to eq("Bloggs")
      end

      it "sets the email address in the auth hash" do
        expect(auth_hash.info.email).to eq("fred.bloggs@example.com")
      end
    end

    context "when authentication fails" do
      before do
        stub_request(:get, "https://fred:secret@mail.example.com/owa/?ae=Dialog&t=AddressBook&ctx=1&sch=fred").
          to_return status: 401
        post "/auth/owa/callback", uid: "fred", password: "secret"
      end

      it "fails with 'invalid_credentials'" do
        expect(last_response).to be_redirect
        expect(last_response.location).to eq "/auth/failure?message=invalid_credentials&strategy=owa"
      end
    end
  end
end
