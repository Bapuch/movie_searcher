require 'uri'
require 'net/http'
require 'json'
require 'themoviedb'


class SearchMovie
  attr_reader :result

  def initialize(search)
    Movie.destroy_all
    @search = search
    @api_key = '61ee53a8c9992efda7bfd2479b778f39'
  end

  def get_result_nogem
    url = URI("https://api.themoviedb.org/3/search/movie?include_adult=false&page=1&query=#{@search}&language=en-US&api_key=#{@api_key}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    Tmdb::Api.key(@search)
    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    @result = JSON.parse(http.request(request).body)
    @result['results'].each do |res|
      crew = Tmdb::Movie.credits(res['id'])['crew']
      director = ""
      crew.each do |c|
        director += "#{c['name']}, " if c['job'] == 'Director'
      end
      director = director.delete_suffix(", ")
      Movie.create!(title: res['title'], release_date: res['release_date'], director: director, poster_path: res['poster_path'])
    end
  end

  def get_result
    Tmdb::Api.key(@api_key)
    @result = Tmdb::Movie.find(@search)
    @result.each do |res|
      crew = Tmdb::Movie.credits(res.id)['crew']
      director = ""
      crew.each do |c|
        director += "#{c['name']}, " if c['job'] == 'Director'
      end
      director = director.delete_suffix(", ")
      Movie.create!(title: res.title, release_date: res.release_date, director: director, poster_path: res.poster_path)
    end
  end
end
