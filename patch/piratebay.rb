module PirateBay
  Search.class_eval do
    BASE_URL = 'https://thepiratebay.se'
    def fetch_search_results
      url = "#{BASE_URL}/search/#{search_string}/#{page}/7/#{category_id}" # highest seeded first
      open(url, { "User-Agent" => "libcurl-agent/1.0", allow_redirections: :all }).read
    end
  end
end
