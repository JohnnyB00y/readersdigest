class SearchesController < ApplicationController

	def search
		search_query = params[:query]
		@results = Algolia.multiple_queries([
			{index_name: "Link", query: search_query},
			{index_name: "User", query: search_query}
		])["results"]

	end
end
