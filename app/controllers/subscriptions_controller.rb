class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[ show edit update destroy ]
  before_action :protected_action, only: %i[ create update destroy ]
  before_action :protected_view, only: %i[ index new edit ]

  # GET /subscriptions or /subscriptions.json
  def index
    @subscriptions = Subscription.all
  end

  # GET /subscriptions/1 or /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions or /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription, notice: "Subscription was successfully created." }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1 or /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription, notice: "Subscription was successfully updated." }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1 or /subscriptions/1.json
  def destroy
    @subscription.destroy!

    respond_to do |format|
      format.html { redirect_to subscriptions_path, status: :see_other, notice: "Subscription was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def subscribe
    if Subscription.exists?(user: Current.user)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("subscribe-cta", partial: "subscribe_cta") }
      end
    else
      s = Subscription.new
      s.user = Current.user
      s.save!

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("subscribe-cta", partial: "subscribe_cta") }
      end
    end
  end

  def unsubscribe
    s = Subscription.find_by(user: Current.user)
    if s.nil?
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("subscribe-cta", partial: "subscribe_cta") }
      end
    else
      s.destroy!

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("subscribe-cta", partial: "subscribe_cta") }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subscription_params
      params.expect(subscription: [ :user_id, :meta ])
    end
end
