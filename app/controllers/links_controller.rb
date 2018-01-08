class LinksController < ApplicationController
  
	 before_action :authenticate_user!, except: [:index, :show]
  before_action :tag_cloud

def new
  @link = Link.new


      end
      
def newest
  @tags = Link.tag_counts_on(:tags)
  if params[:tag]
    @links = Link.newest.tagged_with(params[:tag])
  else
    @links = Link.newest
  end
end

def create
  @link = current_user.links.new(link_params)

  # if @link.save
  #   redirect_to root_path
  # else
  #   render :new
  # end
        # if s = Link.find_similar_by_url(@link.url)
        #   if s.is_recent?
        #   # user won't be able to submit this link as new, so just redirect
        #   # them to the previous link
        #   flash[:success] = "This URL has already been submitted recently."
        #   return redirect_to root_path
        # else
        #   # user will see a warning like with preview screen
        #   @link.already_posted_link = s
        # end
        # end

    
      if @link.save
        return redirect_to link_path(@link), notice: 'Link successfully created'
      else

        render :new
      end


  end

def index
  @tags = Link.tag_counts_on(:tags)
  if params[:tag]
    @links = Link.hottest.tagged_with(params[:tag])
  else
    @links = Link.hottest
  end
end

  def show
  	
  	@link = Link.find_by(id: params[:id])
  	@comments = @link.comments
  end

def edit
  link = Link.find_by(id: params[:id])

  if current_user.owns_link?(link)
    @link = link
  else
    redirect_to root_path, notice: 'Not authorized to edit this link'
  end
end

def update
  @link = current_user.links.find_by(id: params[:id])

  if @link.update(link_params)
    redirect_to root_path, notice: 'Link successfully updated'
  else
    render :edit
  end
end

  def tag_cloud
   @tags = Link.tag_counts_on(:tags).order('count desc').limit(20)
  end
  
def destroy
   link = Link.find_by(id: params[:id])

  if current_user.owns_link?(link)
    link.destroy
    redirect_to root_path, notice: 'Link successfully deleted'
  else
    redirect_to root_path, notice: 'Not authorized to delete this link'
  end
end

def upvote
  link = Link.find_by(id: params[:id])

  if current_user.upvoted?(link)
    current_user.remove_vote(link)
  else
    current_user.upvote(link)
  end
  link.calc_hot_score
  redirect_to root_path
end

  private

def link_params
  params.require(:link).permit(:title, :url, :description, :image, :tag_list)
end

def set_variables
  @link = Link.find_by(id: params[:link_id])
  @comment = @link.comments.find_by(id: params[:id])
end



end
