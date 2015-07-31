require 'jwt'
class AuthToken
  def self.encode(payload, exp=24.hours.from_now)
  	payload[:exp] = exp.to_i
  	JWT.encode(payload, nil, 'none')
  rescue
    nil # It will raise an error if it is not a token that was generated with our secret key or if the user changes the contents of the payload
  end
  
  def self.decode(token)
    return nil if token.nil?
    payload = JWT.decode(token, nil, false)
    payload[0]
  rescue JWT::ExpiredSignature
    fail JWT::ExpiredSignature
  rescue
    puts $!, $@ # It will raise an error if it is not a token that was generated with our secret key or if the user changes the contents of the payload
  end
end