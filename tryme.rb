require './lib/duckdoc.rb'

doc = <<-EOS
Sample Documentation
====================

We will proceed in the following order:

* Demonstrate the use of basic markdown
* Showcase an active DuckDoc code fragment
* ...
* Profit!

As an example we will document [GitHub's](https://github.com/) sign up form.

Have a look at the following screenshot:

||| DuckDoc
visit 'https://github.com/'
screenshot
|||

And now have a look at just the relevant portion with
some fancy ass annotations! **Seriously**, this _might blow your mind_!

||| VisibleDuckDoc
annotate 'form .textfield', 'You enter your information here'
annotate 'form .button', 'And then click here', background: 'rgba(20,200,20,0.75)'
screenshot selector: annotations_clip_box(padding_left: 400)
|||

And this concludes the demo. Let's close like good things do ... with a quote!

> Find joy in everything you choose to do. Every job, relationship, home... it's your responsibility to love it, or change it.

&mdash; Chuck Palahniuk
EOS

ddd = DuckDoc::Document.new(doc)
File.write('example_doc.html', ddd.to_html)

# ddb = DuckDoc::Browser.new

# ddb.action do
#   visit 'https://github.com/'
#   annotate 'form .textfield', 'Enter your information'
#   annotate 'form .button', 'And click here!', background: 'rgba(20,200,20,0.75)'
#   save_screenshot 'clipbox.png', selector: annotations_clip_box(padding_left: 400)
#   remove_annotations
#   annotate 'form .button', 'And click here!', background: 'rgba(20,200,20,0.75)'
#   save_screenshot 'window.png'
#   #save_screenshot 'full_page.png', full: true
# end
