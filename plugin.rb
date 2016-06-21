# name: Dictionary Card Onebox
# about: an internal onebox for Dictionary Cards

register_asset 'stylesheets/dictionary-card-onebox.scss'

after_initialize do
  Onebox::Engine::DiscourseLocalOnebox.class_eval do
    alias_method :super_to_html, :to_html

    def to_html
      uri = URI::parse(@url)
      route = Rails.application.routes.recognize_path(uri.path.sub(Discourse.base_uri, ""))
      url = @url.sub(/[&?]source_topic_id=(\d+)/, "")
      source_topic_id = $1.to_i

      if route[:controller] == 'topics' &&
          ((route[:post_number].present? && route[:post_number].to_i == 1) ||
              (route[:post_number].blank?))
        topic = Topic.where(id: route[:topic_id].to_i).includes(:user).first
        category_slug = topic.category.slug

        if category_slug == 'dictionary'
          post = topic.posts.first
          posters = topic.posters_summary.map do |p|
            {
                username: p[:user].username,
                avatar: PrettyText.avatar_img(p[:user].avatar_template, 'tiny'),
                description: p[:description],
                extras: p[:extras]
            }
          end
          image_url = topic.image_url
          content = post.cooked
          args = { original_url: url,
                   title: PrettyText.unescape_emoji(CGI::escapeHTML(topic.title)),
                   avatar: PrettyText.avatar_img(topic.user.avatar_template, 'tiny'),
                   posts_count: topic.posts_count,
                   last_post: FreedomPatches::Rails4.time_ago_in_words(topic.last_posted_at, false, scope: :'datetime.distance_in_words_verbose'),
                   age: FreedomPatches::Rails4.time_ago_in_words(topic.created_at, false, scope: :'datetime.distance_in_words_verbose'),
                   views: topic.views,
                   posters: posters,
                   content: content,
                   image_url: image_url,
                   category_html: CategoryBadge.html_for(topic.category),
                   topic: topic.id }

          return Mustache.render(File.read("#{Rails.root}/plugins/dictionary-card-onebox/lib/onebox/templates/dictionary_card_onebox.hbs"), args)
        else
          super_to_html
        end
      else
        super_to_html
      end
      super_to_html
    end
  end
end