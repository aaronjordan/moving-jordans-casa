class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    @events = Event.all.order(:start_time)
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def event_params
      values = params.expect(event: [ :title, :desc, :start_time, :end_time, :location, :address, :cover_image ])
      cast_to_utc values
      values
    end

    def cast_to_utc(values)
      if values[:start_time].present?
        latest = Time.zone.parse(values[:start_time])
        unless latest == @event&.start_time
          logger.info "casting time to UTC from CT #{values[:start_time]}"
          as_offset = latest.change(offset: ActiveSupport::TimeZone["US/Central"])
          as_utc = as_offset.utc
          logger.info "saving shifted time as #{as_utc}"
          values[:start_time] = as_utc
        end
      end

      if values[:end_time].present?
        latest = Time.zone.parse(values[:end_time])
        unless latest == @event.end_time
          logger.info "casting time to UTC from CT #{values[:end_time]}"
          as_offset = latest.change(offset: ActiveSupport::TimeZone["US/Central"])
          as_utc = as_offset.utc
          logger.info "saving shifted time as #{as_utc}"
          values[:end_time] = as_utc
        end
      end
    end
end
