module RatingHelper


	def attribute_list(voting, attribute, id)
		html_list = ""
		opposite = attribute == 'tag' ? 'subject' : 'tag'

		# header
		if !current_user
			html_list += "<h3>#{opposite.capitalize}</h3>"
		elsif voting
			html_list += "<h3>#{opposite.capitalize} - <a href='?'>done</a></h3>"
		else
			html_list += "<h3>#{opposite.capitalize} - <a href='?vote'>vote</a></h3>"
		end

		if voting
			list = Rating.joins("ratings, #{opposite}s")
			  .where("ratings.#{opposite}_id = #{opposite}s.id")
			  .where("#{attribute}_id = #{id}")
			  .select("ratings.id as id, ratings.name as name, #{opposite}s.name as attribute_name, #{opposite}s.description as attribute_description")
			  .order("#{opposite}_name asc")

			# tag drop down
			if Tag.count > list.length
          		html_list += "<strong>Add tag:</strong><br><div class='ui form'>"
          		html_list += capture do
	          		form_for Rating.new, :html => { :class => 'fields'} do |f|
	          			concat f.hidden_field "#{attribute}_id", :value => id
	          			concat f.hidden_field :f, :value => :s
	          			concat f.collection_select :tag_id, Tag.where.not(id: list.pluck("#{opposite}_id")).order(:name), :id, :name, {:prompt=>false}
	          			concat f.submit 'Add', :class => 'ui button blue'
	          		end
	          	end
	          	html_list += "</div><br><div align='center'>To remove a vote just click it again.</div><br>"
          	end
        	
        	# users votes
			user_votes = Hash[Vote.select(:votable_id, :vote_weight).where(votable_type: :Rating, votable_id: list.pluck(:id), voter_id: current_user).pluck(:votable_id, :vote_weight)]

			list.each do |item|
				html_list += "<div align='center'><strong>#{item.attribute_name}</strong><br>#{item.attribute_description}<br>"
				for i in 0..10 do
					vote_weight = !user_votes[item.id].nil? ? user_votes[item.id] : -999
	                vote_class = vote_weight == i ? 'orange' : ''
	                html_list += link_to i, vote_rating_path(item.name, w: i), remote: true, :class => "toggle_orange circular icon ui mini button #{vote_class}"
				end
				html_list += "<br><br></div>"
			end
		else
			list = Rating.where("#{attribute}_id = #{id}").order(:cached_weighted_average => :desc)

			list.each do |item|
	        	html_list += "<div class='item'>#{item.display(attribute)}</div>"
	    	end
	    end

		[("<div class='ui list'>" + html_list + "</div>").html_safe, list]
	end
end
