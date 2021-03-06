require 'rails_helper'

describe AidApplications::ApplicantsController do
  let(:assister) { create :assister }
  let(:aid_application) { create :eligible_aid_application, creator: assister }

  describe '#edit' do
    context 'when not authenticated' do
      it 'does not allow access' do
        get :edit, params: {
          aid_application_id: aid_application.id,
          organization_id: assister.organization.id,
        }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated' do
      context 'when the demographic fields are nil' do
        before { sign_in assister }

        it 'defaults to Decline to state' do
          get :edit, params: {
              aid_application_id: aid_application.id,
              organization_id: assister.organization.id
          }

          aid_application = assigns(:aid_application)
          expect(aid_application.preferred_language).to eq 'Decline to state'
          expect(aid_application.country_of_origin).to eq 'Decline to state'
          expect(aid_application.sexual_orientation).to eq 'Decline to state'
          expect(aid_application.gender).to eq 'Decline to state'
        end
      end

      context 'when the demographic fields have values' do
        before do
          sign_in assister

          aid_application.update(
            preferred_language: 'Spanish',
            country_of_origin: 'Pakistan',
            sexual_orientation: 'Another sexual orientation',
            gender: 'Transgender: Female to Male'
          )
        end

        it 'uses the existing values' do
          get :edit, params: {
              aid_application_id: aid_application.id,
              organization_id: assister.organization.id
          }

          aid_application = assigns(:aid_application)
          expect(aid_application.preferred_language).to eq 'Spanish'
          expect(aid_application.country_of_origin).to eq 'Pakistan'
          expect(aid_application.sexual_orientation).to eq 'Another sexual orientation'
          expect(aid_application.gender).to eq 'Transgender: Female to Male'
        end
      end

      context 'when locale is already set on the aid application' do
        before do
          sign_in assister
        end

        it 'auto-selects the associated language' do
          get :edit, params: {
              aid_application_id: aid_application.id,
              organization_id: assister.organization.id,
              locale: :ar
          }

          aid_application = assigns(:aid_application)
          expect(aid_application.preferred_language).to eq 'Arabic'
        end
      end
    end
  end

  describe '#update' do
    let(:assister) { create :assister }
    let(:aid_application) { create :eligible_aid_application, creator: assister }

    before { sign_in aid_application.creator }

    it 'updates the aid application' do
      aid_application_attributes = attributes_for(:aid_application, organization: nil, creator: nil)

      put :update, params: {
        aid_application_id: aid_application.id,
        organization_id: assister.organization.id,
        aid_application: aid_application_attributes
      }

      aid_application = assigns(:aid_application)
      expect(aid_application).to be_persisted
      expect(aid_application).to have_attributes(
                                   creator: assister,
                                   organization: assister.organization
                                 )
      expect(aid_application.landline).to eq false
    end

    context 'when submit form action' do
      let!(:aid_application_attributes) { attributes_for(:aid_application, creator: assister) }
      it 'submits the application' do
        expect do
          put :update, params: {
            aid_application_id: aid_application.id,
            organization_id: assister.organization.id,
            aid_application: aid_application_attributes,
            form_action: 'submit'
          }
        end.to change { aid_application.reload.submitted_at }.from(nil).to(within(1.second).of(Time.current))
           .and change { aid_application.reload.submitter }.from(nil).to(assister)
           .and change { aid_application.reload.application_number }.from(nil).to(anything)
      end

      context 'when the aid application is already submitted' do
        let!(:aid_application) { create :aid_application, :submitted, organization: assister.organization, creator: assister }

        it 'does send any messages' do
          expect do
            put :update, params: {
                aid_application_id: aid_application.id,
                organization_id: assister.organization.id,
                aid_application: attributes_for(:aid_application, organization: nil, creator: nil),
                form_action: 'submit'
            }
          end.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
        end
      end
    end
  end
end
