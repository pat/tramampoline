class SingleDomain
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env['HTTP_HOST'] =~ /trampolinemelb/i
      [301, {'Location' => request(env)}, ['Redirecting...']]
    else
      @app.call(env)
    end
  end
  
  private
  
  def request
    Rack::Request.new(env).url.sub(/trampolinemelb/i, 'trampolineday')
  end
end
