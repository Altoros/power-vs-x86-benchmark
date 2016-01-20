require 'terminal-table'

module HandyPrint
  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end
  
  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end

  def app_table(apps)
    rows = apps.map { |app| [app.name, app_status(app.status), app.error, app.route] }
  	Terminal::Table.new rows: rows, headings: ['Name', 'Status', 'Error', 'Route']
  end

  def app_status(s)
    s.upcase == 'DEPLOYED' ? green(s.upcase) : red(s.upcase)
  end  

  def print_app_table(apps)
    puts
    puts green('Results:'.upcase)
    puts
    puts app_table(apps)
    puts
  end

  def app_route(app_name, api_url)
    cf_domain = api_url.match(/.+api\.(.+)/).to_a.last
    "http://#{app_name}.#{cf_domain}"
  end
end