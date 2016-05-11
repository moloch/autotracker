class Api

  private

  attr_writer :url, :token

  public

  def initialize(url, token)
    @url = url
    @token = token
  end

  def create_time_entry(time_entry)
    uri = URI.parse(@url)
    response = Net::HTTP::Post.new("/v1.1/auth")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth @token, 'api_token'
    request.add_field('Content-Type', 'application/json')
    request.body = time_entry.to_json
    response = http.request(request)
    return response.body
  end

end