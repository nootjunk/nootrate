class Comment < ActiveRecord::Base
	delegate :url_helpers, to: 'Rails.application.routes' 
	acts_as_votable
	
	def link
		"<a href='#{url_helpers.comment_path(self)}'>#{id}</a>".html_safe
	end

	def rating
		cached_votes_score
	end

	def date
		created_at.strftime("%B %d, %Y")
	end
	
	def upvotes
		cached_votes_up
	end

	def downvotes
		cached_votes_down
	end

	def rating_link
		subject_safe_name = subject_name.parameterize('_')
		tag_safe_name = tag_name.parameterize('_')
		"<a href='#{url_helpers.rating_path(subject_safe_name)}-#{tag_safe_name}'><i class='icon bar chart'></i></a><a class='subject' href='#{url_helpers.subject_path(subject_safe_name)}'>#{subject_name}</a> / <a class='tag' href='#{url_helpers.tag_path(tag_safe_name)}'>#{tag_name}</a>".html_safe
	end

	def as_html
		"<div class='event'>
			<div class='label'>
		  		<a title='upvote' data-remote='true' href='#{url_helpers.vote_comment_path(self, w: 1)}'><i data-w='1' class='toggle_orange icon chevron up'></i></a>
		  		<div class='rating' data-w='#{self.rating}' align='center'>#{self.rating}</div>
		  		<a title='downvote' data-remote='true' href='#{url_helpers.vote_comment_path(self, w: -1)}'><i data-w='-1' class='toggle_orange icon chevron down'></i></a>
			</div>
			<div class='content'>
				<div class='summary'>
					#{rating_link} 
					<a href='#{url_helpers.comment_path(self)}' class='date'>#{self.date}</a>
				</div>
				<div class='extra text'>#{self.comment}</div>
				<div class='meta'>#{self.upvotes} upvotes &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{self.downvotes} downvotes</div>
			</div>
		</div>".html_safe
	end
end
