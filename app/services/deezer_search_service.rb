class DeezerSearchService
  def self.search_tracks(query)
    url = URI("https://deezerdevs-deezer.p.rapidapi.com/search?q=#{URI.encode_www_form_component(query)}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '16b5ea9f94msha6a7f82dbf36c77p14c1a2jsn9c9ff4453cd8'
    request["X-RapidAPI-Host"] = 'deezerdevs-deezer.p.rapidapi.com'

    response = http.request(request)

    # Ensure the response is parsed as JSON
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end
end