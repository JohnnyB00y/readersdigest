class LinksController < ApplicationController
	 before_action :authenticate_user!, except: [:index]
def new
  @link = Link.new


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
		@links = Link.all
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

def destroy
   link = Link.find_by(id: params[:id])

  if current_user.owns_link?(link)
    link.destroy
    redirect_to root_path, notice: 'Link successfully deleted'
  else
    redirect_to root_path, notice: 'Not authorized to delete this link'
  end
end

  private

def link_params
  params.require(:link).permit(:title, :url, :description, :image)
end

def set_variables
  @link = Link.find_by(id: params[:link_id])
  @comment = @link.comments.find_by(id: params[:id])
end

end
