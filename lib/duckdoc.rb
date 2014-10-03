Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'duckdoc', '*.rb'))].each{|f| require f}

module DuckDoc
end
