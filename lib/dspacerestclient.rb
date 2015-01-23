require 'rest-client'

require File.dirname(__FILE__) + '/dspacerestclient/community'

class DspaceRestClient

  attr_reader :dspaceurl, :headers, :token

  #---------------------------------------------------
  def initialize(args)
    @dspaceurl = args[:dspaceurl] or raise ArgumentError, "must pass :dspaceurl"

    #:content_type => :json
    default_headers = {
      :accept => :json
    }
    @headers = args[:headers] || default_headers
    @token = args[:token] || {}
    @authenticated = false

    @request = RestClient::Resource.new(
      @dspaceurl,
      :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
      :headers => @headers,
    )
  end
  #---------------------------------------------------

  def get_communities
    response = @request['/communities'].get


    JSON.parse(response).each do |record|
      puts record.id
    end
  end

  def login (username, password)
    data = JSON.generate({:email=>username,:password=>password})
    response = post('/login',data)
    @token = {:'rest-dspace-token' => response}
  end

  def logout
    post('/logout',[])
  end

  def status
    get('/status')
  end

  def test
    get('test')
  end

end
