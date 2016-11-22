class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  # GET /events
  def index
    @nyevents = Event.where(location: "New York, NY").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @sfevents = Event.where(location: "San Francisco, CA").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @chievents = Event.where(location: "Chicago, IL").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @bosevents = Event.where(location: "Boston, MA").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @laevents = Event.where(location: "Los Angeles, CA").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @dcevents = Event.where(location: "Washington, DC").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    set_tags  
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    set_tags  
  end

  # GET /events/1/edit
  def edit
    guard_against_tampering(@event)
    set_tags  
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      @event_tag = EventTag.new(event_id: @event.id, tag_id: Tag.find(params[:event][:tag]).id)
      if @event_tag.save
        redirect_to @event, notice: 'Event was successfully created.'
      else
        set_tags  
        render :new
      end
    end
  end

  # PATCH/PUT /events/1
  def update
    guard_against_tampering(@event)
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    guard_against_tampering(@event)
    @event_tags = EventTag.where(event_id: @event.id)
    @event_tags.each { |event_tag| event_tag.destroy }
    @event.destroy
    redirect_to events_url, notice: "Your event, '#{@event.title}' was successfully deleted."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_tags
      @tags = Tag.all
    end

    # Warden method to prevent non-admins from editing content that is not their own
    def guard_against_tampering(event)
      if event.user != current_user # Must be the event's owner
        if current_user.admin? != true # or they must be a site Administrator
          redirect_to event, alert: "You are not the creator of this event or a Protest45 Admin."
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(
        :user_id,
        :title,
        :description,
        :datetime,
        :address1,
        :address2,
        :city,
        :state,
        :zip,
        :location,
        :url,
        :event_source,
        :approved?)
    end
end
