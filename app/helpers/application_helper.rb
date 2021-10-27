module ApplicationHelper
	def sortable(column, title = nil)
		title ||= column.titleize
		direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
		link_to title, :sort => column, :direction => direction
	end

	def compare_symbol(str)
		case str
		when "gte"
			return ">="
		when "gt"
			return ">"
		when "eq"
			return "="
		when "lt"
			return "<"
		else
			return "<="
		end
	end

	def email_to_name(email)
		case email
		when "jessewjt@gmail.com"
			return "Jiatao"
		when "j.hajek@unimelb.edu.au"
			return "JH"
		when "timothy.brickell@unimelb.edu.au"
			return "Tim"
		end

	end
end
