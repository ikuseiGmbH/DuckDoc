require 'capybara/dsl'
require 'capybara/poltergeist'

module DuckDoc
  class Browser
    include Capybara::DSL
    include JsInjections
    attr_reader :shot_counter, :last_shots

    def initialize(opts={})
      Capybara.run_server = false
      Capybara.register_driver(:poltergeist){ |app|
        Capybara::Poltergeist::Driver.new(app, {
          js_errors: false,
          phantomjs_options: ['--ignore-ssl-errors=yes']
        }.merge(opts)
      )}
      Capybara.current_driver = :poltergeist
      page.driver.resize(1280, 1024)
      page.driver.headers = {'User-Agent' => "DuckDoc #{DuckDoc::VERSION}"}
      @shot_counter = 0
      @last_shots = []
    end

    def action(&block)
      @last_shots = []
      instance_eval(&block) if block_given?
    end

    def screenshot(opts={})
      name = opts.delete(:name) || "shot_#{(@shot_counter+=1).to_s.rjust(4,'0')}.png"
      save_screenshot(name, opts)
      @last_shots << name
    end

    # Add some convenience so you can omit "page.driver"
    def method_missing(m, *args)
      page.driver.respond_to?(m) ? page.driver.send(m, *args) : super
    end

    def respond_to?(m)
      page.driver.respond_to?(m)
    end
  end
end
