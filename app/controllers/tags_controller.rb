class TagsController < ApplicationController
def index
  @tags = Link.tag_counts_on(:tags).limit(8)
  if params[:tag]
    @links = Link.hottest.tagged_with(params[:tag])
  else
    @links = Link.hottest
  end
end

  def show
    @tags = ActsAsTaggableOn::Tag.all
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @links = Link.tagged_with(@tag.name)
  end
end