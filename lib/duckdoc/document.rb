require 'maruku'

module Maruku::In::Markdown
  module DuckDoc
    OPEN  = /^[\|]{3,}\s*(Visible)?DuckDoc\s*$/i
    CLOSE = /^[\|]{3,}\s*$/
  end
end

MaRuKu::In::Markdown::register_block_extension(
  regexp: Maruku::In::Markdown::DuckDoc::OPEN,
  handler: lambda do |doc, src, ctx|
    first = src.shift_line
    first =~ Maruku::In::Markdown::DuckDoc::OPEN
    visible = !!$1
    close = Maruku::In::Markdown::DuckDoc::CLOSE
    lines = []
    while src.cur_line
      if src.cur_line =~ close
        src.shift_line
        break
      else
        lines << src.shift_line
      end
    end
    source = lines.join("\n")
    block = eval "proc { #{source} }" # Evel Knievel
    doc.attributes[:duckdoc_browser].action(&block)
    doc.attributes[:duckdoc_browser].last_shots.each do |shot|
      ctx.push doc.md_im_image([], shot, shot)
    end
    ctx.push doc.md_codeblock(source, 'ruby', nil) if visible
    true
  end
)

module DuckDoc
  class Document
    def initialize(text, opts={})
      text = text.is_a?(IO) ? text.read : text
      @browser = opts[:browser] || DuckDoc::Browser.new
      @doc = Maruku.new(text, duckdoc_browser: @browser)
    end

    def to_html
      @doc.to_html
    end
  end
end
