require 'optparse'

class Parser

  def options_description
    @options_description ||= { host:     "Cloud Foundry api endpoint.",
                               user:     "Cloud Foundry admin user.",
                               password: "Password for Cloud Foundry user." }
  end

  def options
    @options ||= {org: "demo", space: "demo"}
  end
  
  def parse
    option_parser = OptionParser.new do |opts|
      opts.banner = "Usage: deploy [options]"
      options_description.each_pair do |name, description|
        opts.on("-#{name[0]}", "--#{name} [string]", String, description) do |value|
          options[name] = value
        end
      end
    end
    
    option_parser.parse!
    
    options_description.keys.each do |name|
      unless options.include?(name)
        options[name] = (ENV["CF_#{name.upcase}"] || raise("Cloud Foundry #{name} is not specified."))
      end
    end

    options
  end

end
