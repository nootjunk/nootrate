class Rating < ActiveRecord::Base
	acts_as_votable
	has_one :subject
	has_one :tag
	
	delegate :url_helpers, to: 'Rails.application.routes'
	
	def to_param
		name
	end

	def subject_safe_name
		subject_name.parameterize('_')
	end

	def tag_safe_name
		tag_name.parameterize('_')
	end

	def display(attribute)
		(attribute == 'tag' ? subject_link : tag_link) + " - <a class='rating' href='#{url_helpers.rating_path(self)}'>#{votes} votes</a>
		<div class='ui small progress #{attribute=='tag'? 'teal' : 'grey'}' data-percent='#{average}'>
			<div class='bar' style='width:#{average}%;'>
				<div class='progress'>#{average}</div>
			</div>
		</div>".html_safe
	end

	def link
		"<i class='circular ui label'><a class='rating'  title='#{average}%'>#{average}</a></i>".html_safe
	end

	def subject_link
		"<a class='subject' href='#{url_helpers.subject_path(subject_safe_name)}' title='subject'>#{subject_name}</a>".html_safe
	end

	def tag_link
		"<a class='tag' href='#{url_helpers.tag_path(tag_safe_name)}' title='tag'>#{tag_name}</a>".html_safe
	end
	
	def average
		(cached_weighted_average * 10.0).round(0)
	end

	def votes
		ActiveSupport::NumberHelper.number_to_delimited(cached_votes_total)
	end
end
