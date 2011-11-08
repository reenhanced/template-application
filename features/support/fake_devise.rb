class FakeDevise
  cattr_accessor :user_tokens

  def initialize
    @@user_tokens = {}
  end

  def stub_facebook_login_with(member_hash)
    access_token      = member_hash['access token']
    email             = member_hash['email']
    access_token_hash = {:access_token => access_token}

    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'facebook',
      'access_token' => access_token,
      'extra' => { 'user_hash' => { 'email' => email } }
    }
  end
end

Before do
  $fake_devise = FakeDevise.new
  OmniAuth.config.test_mode = true
end
