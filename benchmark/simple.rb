$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'grape_v0_14_0'
require 'benchmark/ips'

class API < GrapeV0_14_0::API
  prefix :api
  version 'v1', using: :path
  get '/' do
    'hello'
  end
end

options = {
  method: 'GET'
}

env = Rack::MockRequest.env_for('/api/v1', options)

10.times do |i|
  env["HTTP_HEADER#{i}"] = '123'
end

Benchmark.ips do |ips|
  ips.report('simple') do
    API.call env
  end
end
