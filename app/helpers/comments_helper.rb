module CommentsHelper
	def comment_list(options = {})
		comments = Comment.where(options).order(:cached_votes_score => :desc)
		if comments.size > 0
			comments_html = ""
			comments.each do |comment|
				comments_html += comment.as_html
			end
			("<div class='items ui feed'><div class='ui horizontal divider'>Comments</div>" + comments_html + "</div>").html_safe
		end
	end
end
