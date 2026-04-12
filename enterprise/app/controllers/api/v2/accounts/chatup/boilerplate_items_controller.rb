class Api::V2::Accounts::Chatup::BoilerplateItemsController < Api::V1::Accounts::BaseController
  before_action :fetch_item, only: [:show, :update, :destroy]
  before_action -> { check_authorization(Chatup::BoilerplateItem) }

  def index
    @items = Current.account.chatup_boilerplate_items.order(created_at: :desc)
    render json: @items
  end

  def show
    render json: @item
  end

  def create
    @item = Current.account.chatup_boilerplate_items.create!(item_params)
    render json: @item
  end

  def update
    @item.update!(item_params)
    render json: @item
  end

  def destroy
    @item.destroy!
    head :no_content
  end

  private

  def fetch_item
    @item = Current.account.chatup_boilerplate_items.find(params[:id])
  end

  def item_params
    params.require(:boilerplate_item).permit(:name, data: {})
  end
end
