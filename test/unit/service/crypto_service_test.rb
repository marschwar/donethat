require 'test_helper'

class CryptoServiceTest < ActiveSupport::TestCase
  setup do
    @service = CryptoService.new
  end

  context 'string encryption' do
    setup do
      @secret = '1234567890'
    end

    should 'fail for missing key' do
      assert_raises(RuntimeError) do
        @service.encrypt_string('data', nil)
      end
    end

    should 'fail for wrong secret' do
      encrypted = @service.encrypt_string('data', @secret)
      decrypted = @service.decrypt_string(encrypted, "#{@secret}XXX")

      assert decrypted.blank?
    end

    should 'be reversible' do
      encrypted = @service.encrypt_string('data', @secret)
      decrypted = @service.decrypt_string(encrypted, @secret)

      assert_equal 'data', decrypted
    end

    should 'be cascadable' do
      server_secret = '123456'
      user_secret = 'abcdef'
      server_encrypted = @service.encrypt_string('data', server_secret)
      user_encrypted = @service.encrypt_string(server_encrypted, user_secret)

      decrypted = @service.decrypt_string(@service.decrypt_string(user_encrypted, user_secret), server_secret)

      assert_equal 'data', decrypted
    end
  end

  context 'hash encryption' do

    should 'be reversible' do
      data = {'a' => 123456789, 'b' => 'abcdef'}
      secret = '1234567890'

      encrypted = @service.encrypt_hash(data, secret)
      decrypted = @service.decrypt_hash(encrypted, secret)

      assert_equal data, decrypted
    end
  end
end