class QuestionsController < ApplicationController
  before_filter :login_required

  before_filter :resolve_company_event

  # the next two methods are needed to include the TextHelper in the controller
  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end


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

		@xml_data = "<graph yAxisName='Votes' showNames='1' decimalPrecision='0' formatNumberScale='0' showBarShadow='1'>"
			@question.answers.each do |answer|
				@xml_data += "<set name='#{answer.escaped_value}' value='#{Vote.count(:all, :conditions => ["answer_id = ?", answer.id])}' showName='1' color='#{help.cycle "0099FF", "CCCC00", "AFD8F8", "F6BD0F", "FF0000", "006F00"}'/>"			
			end
		@xml_data += "</graph>"
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new
    2.times {@question.answers.build}

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
        format.html { redirect_to( company_event_question_url(@company, @event, @question)) }
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
    if @question.active == false
      flash[:error] = "Sorry, question is closed for voting."
      redirect_to company_event_question_url(@company, @event, @question)
      return
    end
    @answer = @question.answers.find(params[:answer_id])
    user_votes = Vote.count(:all, :include => :answer, :conditions => ["answers.question_id = ? and user_id = ?", @question, current_user])
    if(user_votes == 0)
      #create new vote
      vote = @answer.votes.create
      vote.user = current_user
      vote.answer = @answer
      vote.save
      #update score in question
      flash[:notice] = 'You voted successfully.'
    else
      flash[:error] = "Can't vote more then once."
    end
    redirect_to( company_event_question_url(@company, @event, @question)) 
  end  

  def open_voting
    @question = @event.questions.find(params[:id])
    @question.active = true
    @question.save
    redirect_to company_event_question_url(@company, @event, @question)
  end  

  def close_voting
    @question = @event.questions.find(params[:id])
    @question.active = false
    @question.save
    redirect_to company_event_question_url(@company, @event, @question)
  end  

  
protected
  def resolve_company_event
    @company = current_user.companies.find(params[:company_id])
    @event = @company.events.find(params[:event_id])
  end
end
