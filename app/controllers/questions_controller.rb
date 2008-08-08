class QuestionsController < ApplicationController
  before_filter :login_required

  before_filter :resolve_company_event

  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    @question.event = @event

    respond_to do |format|
      if @question.save
        flash[:notice] = 'Question was successfully created.'
        format.html { redirect_to( company_event_url(@company, @event)) }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = @event.questions.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        flash[:notice] = 'Question was successfully updated.'
        format.html { redirect_to company_event_url(@company, @event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(company_event_url(@company, @event)) }
      format.xml  { head :ok }
    end
  end
  
  def update_score
    @question = @event.questions.find(params[:id])
    @value = params[:value]
    user_votes = Vote.count(:score, :conditions => ["question_id = ? and user_id = ?", @question, current_user])
    if(user_votes == 0)
      #create new vote
      
      vote = @question.votes.create
      vote.user = current_user
      vote.score = @value
      vote.save
      #update score in question
      @question.score = Vote.sum(:score, :conditions => ["question_id = ?", @question])*100 / Vote.count(:score, :conditions => ["question_id = ?", @question])
      @question.save    
      flash[:notice] = 'You voted successfully.'
    else
      flash[:error] = "Can't vote more then once."
    end
    redirect_to( company_event_url(@company, @event)) 
    
  end  

  
protected
  def resolve_company_event
    @company = Company.find(params[:company_id])
    @event = @company.events.find(params[:event_id])
  end
end
