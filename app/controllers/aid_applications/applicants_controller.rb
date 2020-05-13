module AidApplications
  class ApplicantsController < BaseController
    def edit
      @aid_application = current_aid_application

      @aid_application.country_of_origin ||= AidApplication::DEMOGRAPHIC_OPTIONS_DEFAULT
      @aid_application.sexual_orientation ||= AidApplication::DEMOGRAPHIC_OPTIONS_DEFAULT
      @aid_application.gender ||= AidApplication::DEMOGRAPHIC_OPTIONS_DEFAULT
    end

    def update
      @aid_application = current_aid_application
      @aid_application.assign_attributes(aid_application_params)

      if params[:form_action] == 'submit'
        @aid_application.save_and_submit(submitter: current_user)

        if @aid_application.errors.empty?
          if @aid_application.sms_consent?
            ApplicationTexter.basic_message(to: @aid_application.phone_number, body: I18n.t('text_message.app_id', app_id: @aid_application.application_number)).deliver_now
          end

          if @aid_application.email_consent?
            ApplicationEmailer.basic_message(to: @aid_application.email, subject: I18n.t('email_message.app_id.subject', app_id: @aid_application.application_number), body: I18n.t('email_message.app_id.body_html', app_id: @aid_application.application_number)).deliver_now
          end
        end
      elsif params[:form_action] == 'allow_mailing_address'
        @aid_application.allow_mailing_address = true
        @aid_application.save
      else
        @aid_application.save(context: :submit)
      end

      respond_with @aid_application, location: (lambda do
        if @aid_application.submitted?
          edit_organization_aid_application_verification_path(current_organization, @aid_application)
        elsif params[:form_action] == 'allow_mailing_address'
          edit_organization_aid_application_applicant_path(current_organization, @aid_application, :anchor => "mailing-address")
        else
          edit_organization_aid_application_applicant_path(current_organization, @aid_application)
        end
      end)
    end

    def aid_application_params
      params.require(:aid_application).permit(
          :street_address,
          :apartment_number,
          :city,
          :zip_code,
          :allow_mailing_address,
          :mailing_street_address,
          :mailing_apartment_number,
          :mailing_city,
          :mailing_state,
          :mailing_zip_code,
          :sms_consent,
          :email_consent,
          :phone_number,
          :landline,
          :email,
          :receives_calfresh_or_calworks,
          :unmet_food,
          :unmet_housing,
          :unmet_childcare,
          :unmet_utilities,
          :unmet_transportation,
          :unmet_other,
          :name,
          :birthday,
          :preferred_language,
          :country_of_origin,
          { racial_ethnic_identity: [] },
          :sexual_orientation,
          :gender,
          :attestation
      ).each do |_, value|
        value.delete('') # removes arrays with empty string from checkboxes
      end
    end
  end
end