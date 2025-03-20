class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy claim release ]
  before_action :protected_action, only: %i[ create update destroy ]
  before_action :protected_view, only: %i[ new edit claims ]


  # GET /items or /items.json
  def index
    @defaultFilter = Category.new(tag: "all", title: "All Items", id: -1)
    @categories = [ @defaultFilter, *Category.all.order(:title) ]
    @items = Item.all.order(created_at: :desc)
  end

  # GET /items/1 or /items/1.json
  def show
    @categories = Category.all
    @active_claims = ClaimEvent.where(item_id: @item.id).where.not(released: true).order(created_at: :desc)
    @user_claimed_this_item = false

    if authenticated?
      @user_claimed_this_item = @active_claims.exists?(user_id: Current.user.id)
    end
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    ClaimEvent.where(item_id: @item.id).each do |claim|
      claim.destroy!
    end

    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_path, status: :see_other, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def claims
    @claims = ClaimEvent.all.order(created_at: :desc)
  end


  def claim
    if authenticated?
      claim = ClaimEvent.new
      claim.user_id = Current.user.id
      claim.item_id = @item.id
      claim.released = false
      claim.save
      ClaimEventMailer.success_notification(claim).deliver_later
      flash["success"] = "Item claimed."
      redirect_to @item
    else
      redirect_to new_session_path
    end
  end

  def release
    if authenticated?
      claim = ClaimEvent.find_by(item_id: @item.id, user_id: Current.user.id, released: false)
      claim.released = true
      claim.save
      flash["success"] = "Item released."
    end
    redirect_to @item
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.expect(item: [
        :title, :draft, :suggested_price, :reserve_price, :desc,
        :cover_image, images: [], category_ids: []
      ])
    end

    def resize_all_images
      p = item_params

      if p[:cover_image].present?
        resize_image(p[:cover_image], 640, 640)
      end

      if p[:images].present?
        for image in p[:images].each
          resize_image(image, 640, 640)
        end
      end
    end

    private

    def resize_image(src, width, height)
      return unless src

      begin
        ImageProcessing::MiniMagick
          .source(src)
          .resize_to_fill(width, height)
          .call(destination: src.tempfile.path)
        logger.info "DID RESIZE OP ON #{src.tempfile.path}"
      rescue StandardError => _e
        # Do nothing. If this is catching, it probably means the
        # file type is incorrect, which can be caught later by
        # model validations.
      end
    end
end
