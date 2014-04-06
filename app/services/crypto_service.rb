require 'crypt/rijndael'

class CryptoService

  CryptoService::KEY_SIZE = 32

  def encrypt_string(string, secret)
    Base64.strict_encode64 algorithm(secret).encrypt_string string
  end

  def encrypt_hash(hash, secret)
    encrypt_string hash.to_json, secret
  end

  def encrypt_server_hash(hash)
    encrypt_hash hash, Donethat::Application.config.secret_token
  end

  def decrypt_string(encrypted, secret)
    algorithm(secret).decrypt_string Base64.strict_decode64 encrypted
  end

  def decrypt_hash(encrypted, secret)
    plain = decrypt_string encrypted, secret
    JSON.parse plain
  end

  def decrypt_server_hash(encrypted)
    decrypt_hash encrypted, Donethat::Application.config.secret_token
  end

private

  def algorithm(secret)
    Crypt::Rijndael.new key(secret)
  end
  # repeat the secret to match key size
  def key(secret)
    raise "secret too short" unless secret && secret.size > 4
    padding_needed = (CryptoService::KEY_SIZE / secret.size) + 1
    (secret * padding_needed).truncate(CryptoService::KEY_SIZE, omission: '')
  end
end