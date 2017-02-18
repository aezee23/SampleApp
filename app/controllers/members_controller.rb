class MembersController < ApplicationController

  def index
    if current_user && current_user.admin
      if params[:group]
        group = ChurchGroup.find(params[:group])
        @members = group.members.paginate(page: params[:page], per_page: 70)
        @name = group.name
      elsif params[:user]
        user = User.find(params[:user])
        @members = user.members.paginate(page: params[:page], per_page: 70)
        @name = user.name.split(" ")[0] + "'s"
      elsif params[:church]
        church = Church.find(params[:church])
        @members = church.members.paginate(page: params[:page], per_page: 70)
        @name = church.readable_name
      else
        @members = Member.paginate(page: params[:page], per_page: 70)
        @name = "All"
      end
    elsif current_user && !current_user.admin
      @members = current_user.members.paginate(page: params[:page], per_page: 70) 
      @name = "My"
    end
  end
  
  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def create
    church_group = Church.find(params[:member][:church_id]).church_group
    @member = Member.new(member_params.merge(church_group_id: church_group.id))
    if @member.save
      redirect_to members_path  
      flash[:success] = 'Member was successfully added.'
    else
      flash[:error] = 'Please try again'
      render action: 'new'
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    church_group = Church.find(params[:member][:church_id]).church_group
    new_params = member_params.merge(church_group_id: church_group.id)
    if @member.update_attributes(new_params)
      redirect_to members_path
      flash[:success] = 'Member was successfully updated.'
    else
      flash[:failure] = "Please try again"
      render action: 'edit'
    end
  end

  def destroy
    member = Member.find(params[:id])
    member.destroy
    flash[:success] = "Member deleted"
    redirect_to :back
  end

  private 

  def member_params
    params.require(:member).permit(:email, :name, :avatar, :phone_number, :visited, :church_id, :church_group_id)
  end
end
