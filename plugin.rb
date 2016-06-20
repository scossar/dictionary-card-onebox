# name: Dictionary Card Onebox
# about: an internal onebox for Dictionary Cards

after_initialize do
  Onebox::Engine::DiscourseLocalOnebox.class_eval do
    alias_method :super_to_html, :to_html

    def to_html
      uri = URI::parse(@url)
      route = Rails.application.routes.recognize_path(uri.path.sub(Discourse.base_uri, ""))
      url = @url.sub(/[&?]source_topic_id=(\d+)/, "")
      source_topic_id = $1.to_i

      if route[:controller] == 'topics'
        if (route[:post_number].present? && route[:post_number].to_i == 1) || route[:post_number].blank?
          topic = Topic.find(route[:topid_id])
          return '<h1>this is a dictionary</h1>'
        else
          super_to_html
        end
      end
    end
  end
end