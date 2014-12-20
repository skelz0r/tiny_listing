class Vacuum::LootPlace
  def initialize(params)
    @root_link_sanitizer = params.delete :root_link
    @link_sanitizer = params.delete :link
    @repository = params.delete :repository

    @number_of_loots = 0
  end

  def sack_it!
    extract_nodes.each do |node_link|
      begin
        suck_node(node_link.to_s)
      rescue => e
        logger.error "Unable to fetch #{node_link}: #{e}"
      end
    end
  end

  def loots_count
    @number_of_loots
  end

  protected

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/vacuum.log")
  end

  def suck_node(link)
    head = get_http_head(link)

    if is_file?(head)
      save_file(link, head) unless Loot.find_by(link: link.to_s)
    else
      loot_another_place = Vacuum::LootPlace.new(root_link: @root_link_sanitizer, link: Vacuum::LinkSanitizer.new(link), repository: @repository)
      loot_another_place.sack_it!
      @number_of_loots += loot_another_place.loots_count
    end
  end

  def get_http_head(path)
    response = nil

    Net::HTTP.start(@link_sanitizer.uri.host, @link_sanitizer.uri.port) do |http|
      response = http.head(path)
    end

    response
  end

  # Perform the nodes extraction
  # It returns an absolute link array of files & paths,
  # without the parent directory (avoid dummy loops)
  def extract_nodes
    nodes.each_with_object([]) do |node,links_accu|
      if (node['href'] !~ /^\?/) && (node.inner_html != 'Parent Directory')
        links_accu << Addressable::URI.parse(@link_sanitizer.to_s + node['href']).normalize
      end
    end
  end # extract_nodes()

  def nodes
    @nodes ||= Nokogiri::HTML(open(@link_sanitizer.to_s)).css('a')
  end

  # Parse head content-type to determining if it's a file
  def is_file?(http_head)
    content_type = http_head['content-type']
    if (content_type =~ /html/)
      return false
    end
    true
  end

  # Extract information from HTTP HEAD and create
  # the file
  def save_file(url, head)
    loot = Loot.new({
      :link => url,
      :size => head['content-length'],
      :repository_id => @repository.id
    })
    @number_of_loots += 1 if loot.save
    loot
  end

end
