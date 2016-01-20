require 'rubygems'
require 'sinatra'

get '/' do
  cpu_name = `uname -m`.strip
  erb :index, locals: {cpu: cpu_name}
end

get '/fibonacci/:number' do |number|
  value = (0..number.to_i).inject([1,0]) { |(a,b), _| [b, a+b] }[0]
  erb :number, locals: {number: number, value: value}
end

get '/lscpu' do
  output = `lscpu`
  output = $?.success? ? output.gsub!(/\n/, '<br/>') : 'Command is not supported'
  erb :lscpu, locals: {output: output}
end
