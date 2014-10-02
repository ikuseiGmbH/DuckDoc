require_relative 'duckdoc/version'
require_relative 'duckdoc/js_injections'
require 'capybara/dsl'
require 'capybara/poltergeist'

module DuckDoc

  class Browser
    include Capybara::DSL
    include JsInjections

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
    end

    def action(url = nil, path = nil, &block)
      visit url if url
      instance_eval(&block) if block_given?
      save_screenshot(path) if path
    end

    # Add some convenience so you can omit "page.driver"
    def method_missing(m, *args)
      page.driver.send(m, *args)
    end

    def respond_to?(m)
      page.driver.respond_to?(m)
    end
  end

end

