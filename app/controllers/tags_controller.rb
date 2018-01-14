class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
        @tags = ActsAsTaggableOn::Tag
                .where("name ILIKE ?", "%#{params[:name]}%")
                .where.not(name: params[:tags_chosen])
                .includes(:taggings)
                .where(taggings: {taggable_type: params[:taggable_type]})
        @tags = @tags.where(taggings: {context: params[:context] }) if params[:context]
        @tags.order!(name: :asc)
        render json: @tags
end
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @links = Link.tagged_with(@tag.name)
  end
end