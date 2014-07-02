class SearchController < ApplicationController
  respond_to :json, :html

  def index
    query =  params[:q].strip
    return redirect_to root_path if params[:q].blank?
    @query = query
    query = Article.remove_stop_words query

    # Searchify can't handle requests longer than this
    # (because of query expansion + Tanker inefficencies.
    # >10 can result in >8000 byte request strings)
    if query.split.size > 10 || query.blank?
      @results = []
      return
    end

    @results = Article.search(query).to_a
    respond_with(@results)
  end

  def reindex_articles
    Article.tanker_reindex
    render json: { success: true }
  end
end
