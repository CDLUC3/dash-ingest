module ApplicationHelper

  def google_analytics_js
    '<script>
      (function(i,s,o,g,r,a,m){
        i['GoogleAnalyticsObject']=r;
        i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
        a=s.createElement(o), m=s.getElementsByTagName(o)[0];
        a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})
      (window,document,'script','//www.google-analytics.com/analytics.js','ga');
      ga('create', 'UA-30638119-13', 'auto');
      ga('send', 'pageview');
    </script>'
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end


  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    logger.info "data-id: #{id}"
    logger.info "data-fields: #{fields.gsub("\n", "")}"
    link_to(name, '#', :class => "add_fields btn", data: {id: id, fields: fields.gsub("\n", "")})
  end


end