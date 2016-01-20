require 'erubis'

class Generator

  attr_accessor :context, :options

  def initialize(context, options = {})
    @options = options
  	@context = context
  end

  def generate(source, target, options={})
    # folder = File.dirname(target)
    # FileUtils.mkdir_p(folder)
    template = File.read(File.join(source_folder, source))
    result = Erubis::Eruby.new(template).result(context.merge(options))
    File.write(target, result)
  end

  private 

  def source_folder
    options[:source_folder] || Dir.pwd
  end
end