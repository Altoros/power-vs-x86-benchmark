require 'generator'
require 'parser'
require 'open3'
require 'ostruct'

class String

  def password?
    !!@_password
  end

  def password!
    @_password = true
    self
  end

end


class Deployer

  def cf(*args)
    command = "cf #{args.join(" ")}"
    filtered_command = args.map { |a| a.password? ? "[FILTERED]" : a }.join(" ")
    puts "executing command: #{filtered_command}"
    result = []
    stdin, stdout, stderr, wait_thr = Open3.popen3(command)
    while !(output = stdout.gets).nil?  
      puts output
      result << output
    end
    result.join("\n")
  end

  def cf_exists?(resurse, name)
    !cf(resurse, name).match(/not found$/)
  end

  def manifests_folder
    @manifests_folder ||= File.expand_path("../../manifests", __FILE__)
  end

  def initialize(init_options=nil)
    @options = options.merge(init_options) if init_options
    cf("api", options[:host], "--skip-ssl-validation")
    cf("auth", options[:user], options[:password].dup.password!)
    cf("create-org", options[:org]) unless cf_exists?("org", options[:org])
    cf("target", "-o", options[:org])
    cf("create-space", options[:space]) unless cf_exists?("space", options[:space])
    cf("target", "-s", options[:space])
  end

  def option_parser
    @option_parser ||= Parser.new
  end

  def options
    @options ||= option_parser.parse
  end

  def generator
    @generator ||= Generator.new(options, source_folder: manifests_folder)
  end
  
  def deploy(application, options={})
    app_options = {name: application}.merge(options)
    generator.generate("#{application}.yml", "apps/#{application}/manifest.yml", app_options)
    Dir.chdir("apps/#{application}") do
      output = cf("push")
      # FileUtils.rm_f('manifest.yml')
      app_stats(app_options[:name], output)
    end
  end

  def success?(output)
    !output.match(/FAILED/)
  end

  def error_message(output)
    success?(output) ? '' : output.match(/FAILED\n+(^.+$)/).to_a.last 
  end

  def app_stats(app, output)
    url = output.match(/^urls:\s(.+)/) ? output.match(/^urls:\s(.+)/).to_a.last : ''
    OpenStruct.new( name: app, 
                    status: success?(output) ? 'DEPLOYED' : 'FAILED',
                    error: error_message(output),
                    success?: success?(output), route: url)
  end

  def destroy(app)
    if cf_exists?("app", app)
      app_stats(app, cf("delete", "-f", app))
    else
      app_stats(app, "FAILED\nThere is no such app.\n")
    end
  end

end
