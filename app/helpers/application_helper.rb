module ApplicationHelper
	def title(title = nil)
		if title.present?
			content_for :title, title
		else
			content_for?(:title) ? content_for(:title) + " - " + Rails.application.config.site_name : Rails.application.config.site_name
		end
	end
end
