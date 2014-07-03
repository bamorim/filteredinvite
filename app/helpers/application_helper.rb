module ApplicationHelper
  def rs_checked? rs 
    if params[:filters] && params[:filters][:relationship_status]
      params[:filters][:relationship_status].include?(rs)
    end
  end
end
