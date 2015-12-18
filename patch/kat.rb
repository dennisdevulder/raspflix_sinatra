module Kat
  Search.class_eval do
    def search(page_num = 0)
      @error = nil
      @message = nil

      puts 'test'

      search_proc = lambda do |page|
	 begin
          uri = URI(URI.encode(to_s page))
	  puts uri
          req = Net::HTTP::Get.new(uri.path)
          res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, verify_mode: 0).request(req)
	  puts res

	  if res.code == '301'
	    puts 'hit 301'
	    path = Net::HTTP::Get.new(res.header['location'])
	    res = Net::HTTP.start(uri.host) { |http| http.request path }
	  end

	  @pages = 0 and return if res.code == '404'

	  doc = Nokogiri::HTML(res.body)
	  @results[page] = doc.xpath('//table[@class="data"]//tr[position()>1]/td[1]').map do |node|
	    { path: href_of(node, 'a.torType'),
	      title: node.css('a.cellMainLink').text,
	      magnet:   href_of(node, 'a[title="Torrent magnet link"]'),
	      download: href_of(node, 'a[title="Download torrent file"]'),
	      size: (node = node.next_element).text,
	      files: (node = node.next_element).text.to_i,
	      age: (node = node.next_element).text,
	      seeds: (node = node.next_element).text.to_i,
	      leeches: node.next_element.text.to_i }
	  end

	  if @pages == -1
            p = doc.css('div.pages > a').last
	    @pages = p ? [1, p.text.to_i].max : 1
	  end
	rescue => e
          @error = { error: e }
	end unless @results[page] || (@pages > -1 && page >= @pages)
      end

      pages = (page_num.is_a?(Range) ? page_num.to_a : [page_num])
      pages.unshift(0) if @pages == -1 && !pages.include?(0)
      pages.each { |i| search_proc.call i }
      results[page_num.is_a?(Range) ? page_num.max : page_num]
    end
  end
end
