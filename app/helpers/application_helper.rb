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

	def self.fulltext_search(str)
		

	end
end
