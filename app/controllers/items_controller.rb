class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  # before_action :resize_all_images, only: %i[ create update ]

  # GET /items or /items.json
  def index
    @defaultFilter = Category.new(tag: "all", title: "All Items", id: -1)
    @categories = [ @defaultFilter, *Category.all.order(:title) ]
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
    @categories = Category.all
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
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_path, status: :see_other, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
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
