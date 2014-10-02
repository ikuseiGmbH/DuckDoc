require_relative 'lib/duckdoc'

ddb = DuckDoc::Browser.new

ddb.action do
  visit 'https://github.com/'
  annotate 'form .textfield', 'Enter your information'
  annotate 'form .button', 'And click here!', background: 'rgba(20,200,20,0.75)'
  save_screenshot 'full_page.png', full: true
  save_screenshot 'window.png'
  save_screenshot 'clipbox.png', selector: annotations_clip_box(padding_left: 400)
end
