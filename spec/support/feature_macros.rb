module FeatureMacros
  def mock_facebook_authorization
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '12345',
      info: {
        name: 'mockuser',
        email: 'user@somewhere.com'
      },
      credentials: {
        token:  'mock_token'
      }
    )
  end

  def mock_twitter_authorization
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '12345',
      info: {
        name: 'mockuser'
      },
      credentials: {
        token:  'mock_token',
        secret: 'mock_secret'
      }
    )
  end
end