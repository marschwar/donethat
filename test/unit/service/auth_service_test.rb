require 'test_helper'

class AuthServiceTest < ActiveSupport::TestCase
  setup do
    @service = AuthService.new
  end

  context 'twitter' do
    setup do
      @uid = 'aabbcc'
      @auth_hash = {provider: 'twitter', uid: @uid, info: { name: 'Donald Duck' }, credentials: {token: 'token'}}
    end

    context 'auth_success' do
      should 'create new user if unknown' do
        refute TwitterUser.find_by_identifier(@uid)
        u = @service.handle_auth_success(@auth_hash)
        assert_equal 'Donald Duck', u.name

        u = TwitterUser.find_by_identifier(@uid)
        assert_equal 'Donald Duck', u.name
      end
    end
  end

  context 'google' do
    setup do
      @uid = 'aabbcc'
      @auth_hash = {provider: 'google_oauth2', uid: @uid, info: { name: 'Donald Duck' }, credentials: {token: 'token'}}
    end

    context 'auth_success' do
      should 'create new user if unknown' do
        refute GoogleUser.find_by_identifier(@uid)
        u = @service.handle_auth_success(@auth_hash)
        assert_equal 'Donald Duck', u.name

        u = GoogleUser.find_by_identifier(@uid)
        assert_equal 'Donald Duck', u.name
      end
    end
  end
end