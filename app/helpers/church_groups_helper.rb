module ChurchGroupsHelper
		  def gravatar_fore(church_group, options = { size: 160 })
    gravatar_id = Digest::MD5::hexdigest(church_group.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: church_group.name, class: "gravatar")
  end
end

