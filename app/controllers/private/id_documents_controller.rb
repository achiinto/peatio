module Private
  class IdDocumentsController < BaseController

    def edit
      @id_document = current_user.id_document || current_user.create_id_document
    end

    def update
      @id_document = current_user.id_document

      if @id_document.update_attributes id_docuemnt_params
        # Auto approve id_document verify
        @id_document.submit! if  @id_document.may_submit?
        @id_document.approve! if @id_document.may_approve?

        mixpanel_track :id_document_created, @id_document

        redirect_to settings_path, notice: t('.notice')
      else
        render :edit
      end
    end

    private

    def id_docuemnt_params
      params.require(:id_document).permit(:name, :birth_date, :address, :city, :country, :zipcode,
                                          :id_document_type, :id_document_number, :id_bill_type,
                                          {id_document_file_attributes: [:id, :file]},
                                          {id_bill_file_attributes: [:id, :file]})
    end
  end
end
