class ReportDataController < InheritedResources::Base
  before_action :has_access
  before_action :set_report_datum, only: [:index]

  def index
    if @report_datum.from_address.nil?
      @from_address = "Default From Address" 
    else 
      @from_address = @report_datum.from_address
    end

    if @report_datum.letter_title.nil?
      @letter_title = "Ref : Your letter dated _REQUEST_DATE_ for Verification."
    else 
      @letter_title = @report_datum.letter_title
    end

    if @report_datum.to_address.nil?
      @to_address = "_USER_TO_ADDRESS_"
    else 
      @to_address = @report_datum.to_address
    end

    if @report_datum.subject.nil?
      @subject = "Regarding Education Verification."
    else 
      @subject = @report_datum.subject
    end

    if @report_datum.body.nil?
      @body = "Mollitia suscipit qui consequatur id quo adipisci omnis. Soluta molestiae reprehenderit provident quibusdam dolorem recusandae. Exercitationem culpa aperiam perferendis vitae adipisci nihil sit modi. Atque quia suscipit esse quae dicta vitae. _STATUS_ Autem illum dolorum officiis laborum quis. Deserunt cumque exercitationem id numquam nobis magnam quia voluptatibus. Ea accusamus quia neque dicta est quas. Officiis dicta et aut qui iste in aut."
    else 
      @body = @report_datum.body
    end

    if @report_datum.designation.nil?
      @designation = "Controller of Examination"
    else 
      @designation = @report_datum.designation
    end

    @college = College.select(:name).where(:id => @col_id).first


    respond_to do |format|
      format.html
      format.json {render json: @report_datum}
    end
  end

  # PATCH/PUT /report_data/1
  # PATCH/PUT /report_data/1.json
  def update
    @report_datum = ReportDatum.find_or_create_by(college_id: report_datum_params["college_id"])
    respond_to do |format|
      if @report_datum.update(report_datum_params)
        @report_datum.header.url
        format.html { redirect_to report_data_path(college_id: report_datum_params["college_id"])}
        format.json { render :show, status: :ok, location: @report_datum }
      else
        format.html { render :edit }
        format.json { render json: @report_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  	# Use callbacks to share common setup or constraints between actions.
    def set_report_datum
      if !params[:college_id].nil?
        @col_id = params[:college_id]
      else
        @col_id = current_user.college.id
      end
      @report_datum = ReportDatum.find_or_create_by(college_id: @col_id)
      @report_datum.college_id = @col_id
    end

    def report_datum_params
      params.require(:report_datum).permit(:college_id, :from_address, :to_address, :letter_title, :subject, :body, :designation, :header, :signature)
    end
end

