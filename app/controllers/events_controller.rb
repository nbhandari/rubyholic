class EventsController < ApplicationController
  def index
    @events = Event.find_all_events
    
    if params[:sort_key] == 'group' then
      @events = Event.sort_by_group
    elsif params[:sort_key] == 'location'
      @events = Event.sort_by_location
    end    
  end

  def new
    @event = Event.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end
  
  def create
    @event = Event.new(params[:event])
    
    @event.location = Location.find(@event.location_id)
    @event.group = Group.find(@event.group_id)
    #~ @event.group = Group.find(:all, :conditions => {:name => @event.group_name})[0]
        
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to :action => :index
        #~ format.html { redirect_to(@event) }
        #~ format.xml  { render :xml => @event, :status => :created, :location => @event }
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
    end
  end

end
