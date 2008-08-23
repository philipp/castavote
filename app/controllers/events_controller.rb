class EventsController < ApplicationController
  before_filter :login_required

  before_filter :resolve_company
  
  # GET /events
  # GET /events.xml
  def index
    @events = Event.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @questions = @event.questions.paginate(:page => 1, :page => params[:page], :per_page => 10, :order => "created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.company = @company

    
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to company_url(@company) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = @company.events.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to company_url(@company) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      flash[:notice] = 'Event was successfully deleted.'      
      format.html { redirect_to(company_path(@company)) }
      format.xml  { head :ok }
    end
  end
  
  
protected
  def resolve_company
    @company = current_user.companies.find(params[:company_id])    
  end  
end
