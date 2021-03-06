class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_tags, only: [:new, :edit]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  # GET /events
  def index
    @nyevents = Event.where(approved:true).where(location: "New York, NY").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @sfevents = Event.where(approved:true).where(location: "San Francisco, CA").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @chievents = Event.where(approved:true).where(location: "Chicago, IL").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @bosevents = Event.where(approved:true).where(location: "Boston, MA").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @laevents = Event.where(approved:true).where(location: "Los Angeles, CA").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
    @dcevents = Event.where(approved:true).where(location: "Washington, DC").where("DATE(datetime) >= ?", Date.today - 1.day).order("datetime ASC")
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    guard_against_tampering(@event)
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.picture_url = Event.get_FB_picture_url( event_params['event_source'], event_params['url'] )
    if @event.save
      EventTag.create(event_id: @event.id, tag_id: Tag.find(params[:event][:tag]).id)
      redirect_to @event, notice: 'Thank you for submitting an event! It will be reviewed by an administrator shortly.'
    else
      set_tags
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    guard_against_tampering(@event)
    tag = Tag.find(params[:event][:tag])
    @event_tag = EventTag.find_by(event_id: @event.id)
    if @event.update(event_params) && @event_tag.update(tag_id: tag.id)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      set_tags
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

  #Filter Events By Tags

  def filter_by_tag
    if params[:event][:tag_id] == ""
      flash[:notice] = "You must select a tag."
      redirect_to :back
    else
      tag = Tag.find(params[:event][:tag_id])
      @events = tag.events
    end
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
        :approved,
        :event_source)
    end
end
