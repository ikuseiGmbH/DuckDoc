module DuckDoc
  module JsInjections
    def annotate(selector, text, opts={})
      code = <<-EOS
      window.duckdoc_annotation = window.duckdoc_annotation || 0;
      (function(){
        var elems = document.querySelectorAll('#{selector}');
        for(var i=0; i<elems.length; i++){
          var pos = elems[i].getBoundingClientRect();
          var anno = document.createElement('div');
          anno.id = 'duckdoc_annotation_' + duckdoc_annotation++;
          anno.style.background = '#{opts[:background] || 'rgba(200,20,20,0.75)'}';
          anno.style.color = '#{opts[:color] || '#EEE'}';
          anno.style.fontWeight = 'bold';
          anno.style.textShadow = '1px 1px #444';
          anno.style.padding = '10px';
          anno.style.margin = '5px';
          anno.style.borderRadius = '20px';
          anno.style.borderTopLeftRadius = '0';
          anno.style.position = 'absolute';
          anno.style.top = pos.top + pos.height + 'px';
          anno.style.left = pos.left + pos.width + 'px';
          anno.innerHTML = '#{text}';
          document.body.appendChild(anno);
        }
      })();
      EOS
      page.driver.execute_script code
    end

    def annotations_clip_box(opts={})
      id = "duckdoc_clip_box"
      opts[:padding_top]  ||= 100; opts[:padding_bottom] ||= 100
      opts[:padding_left] ||= 100; opts[:padding_right]  ||= 100
      code = <<-EOS
      (function(){
        var xmin=99999,ymin=99999,xmax=0,ymax=0;
        for(var i=window.duckdoc_annotation-1; i>=0; i--){
          var pos = document.getElementById('duckdoc_annotation_' + i).getBoundingClientRect();
          if(pos.left < xmin){ xmin = pos.left; }
          if(pos.top < ymin){ ymin = pos.top; }
          if(pos.left + pos.width > xmax){ xmax = pos.left + pos.width; }
          if(pos.top + pos.height > ymax){ ymax = pos.top + pos.height; }
        }
        xmin-=#{opts[:padding_left]}; xmax+=#{opts[:padding_right]};
        ymin-=#{opts[:padding_top]}; ymax+=#{opts[:padding_bottom]};
        var box = document.createElement('div');
        box.id = '#{id}';
        box.style.position = 'absolute';
        box.style.width = xmax - xmin + 'px';
        box.style.height = ymax - ymin + 'px';
        box.style.top = ymin + 'px';
        box.style.left = xmin + 'px';
        document.body.appendChild(box);
      })();
      EOS
      page.driver.execute_script code
      "##{id}"
    end

    def clip_box(x,y,w,h)
      id = "duckdoc_clip_box"
      code = <<-EOS
      (function(){
        var box = document.createElement('div');
        box.id = '#{id}';
        box.style.position = 'absolute';
        box.style.width = '#{w}';
        box.style.height = '#{h}';
        box.style.left = #{x} + 'px';
        box.style.top = #{y} + 'px';
        document.body.appendChild(box);
      })();
      EOS
      page.driver.execute_script code
      "##{id}"
    end
  end

end
