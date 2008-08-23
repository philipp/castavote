class CompaniesController < ApplicationController
  before_filter :login_required


  # GET /companies
  # GET /companies.xml
  def index
    @companies = current_user.companies.paginate(:page => 1, :page => params[:page], :order => "name DESC")
        
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = current_user.companies.find(params[:id])

    @events = @company.events.paginate(:page => 1, :page => params[:page], :per_page => 10, :order => "date DESC")
    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = current_user.companies.find(params[:id])
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])
    @profile = Profile.new

    respond_to do |format|
      if @company.save
        @profile.company = @company
        @profile.user = current_user
        @profile.save
        
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to(@company) }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = current_user.companies.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to(@company) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = current_user.companies.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end
  
  def generate_new_joining_code
    @company = current_user.companies.find(params[:id])
    @company.generate_new_joining_code
    @company.save
    flash[:notice] = 'New Joining Code was successfully generated.'
    redirect_to(@company)    
  end
  
  
  def join
    @company = Company.find_by_id_and_joining_code(params[:id], params[:joining_code])
    if @company
      if Profile.find_by_company_id_and_user_id(@company.id, current_user.id)
        flash[:notice] = 'Already joined.'
      else
        @profile = Profile.new
        @profile.company = @company
        @profile.user = current_user
        @profile.save
        flash[:notice] = 'Successfully joined the company -- ' + @company.name + "."      
      end
    else
      flash[:error] = 'No company found.'
    end
    redirect_to companies_url
  end
  
end
