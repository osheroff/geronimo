module Geronimo
  module Server
    module Helpers
      def h(text)
        Rack::Utils.escape_html(text)
      end

      def gravatar_url(author, size=50)
        "http://www.gravatar.com/avatar/" + Digest::MD5.hexdigest(author.email.strip.downcase) + "?s=#{size}"
      end
    end
  end
end
