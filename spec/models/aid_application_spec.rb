require 'rails_helper'

RSpec.describe AidApplication, type: :model do
  let(:aid_application) { create :aid_application }

  it 'has a valid factory' do
    aid_application = build :aid_application
    expect(aid_application).to be_valid(:eligibility)
    expect(aid_application).to be_valid(:submit)
  end

  describe '#organization' do
    it 'is required' do
      aid_application.organization = nil
      expect(aid_application).not_to be_valid
      expect(aid_application.errors[:organization]).to include("must exist")
    end
  end

  describe '#creator' do
    it 'is required' do
      aid_application.creator = nil
      expect(aid_application).not_to be_valid
      expect(aid_application.errors[:creator]).to include("must exist")
    end
  end

  describe '#street_address' do
    it 'is required' do
      aid_application = build :aid_application, street_address: ''
      expect(aid_application).not_to be_valid(:submit)
    end
  end

  describe '#city' do
    it 'is required' do
      aid_application = build :aid_application, city: ''
      expect(aid_application).not_to be_valid(:submit)
    end
  end

  describe '#zip_code' do
    it 'is required' do
      aid_application = build :aid_application, zip_code: ''
      expect(aid_application).not_to be_valid(:submit)
    end
    it 'must be valid' do
      aid_application = build :aid_application, zip_code: 'none'
      expect(aid_application).not_to be_valid(:submit)
    end
    it 'cannot be outside of california' do
      aid_application = build :aid_application, zip_code: '89101'
      expect(aid_application).not_to be_valid(:submit)
    end
  end

  describe '#mailing_street_address' do
    it 'is required' do
      aid_application = build :aid_application, mailing_street_address: ''
      expect(aid_application).not_to be_valid(:submit)
    end

    it 'is only required when allow_mailing_address is set to true' do
      aid_application = build :aid_application, allow_mailing_address: false, mailing_street_address: ''
      expect(aid_application).to be_valid(:submit)
    end
  end

  describe '#mailing_city' do
    it 'is required' do
      aid_application = build :aid_application, mailing_city: ''
      expect(aid_application).not_to be_valid(:submit)
    end

    it 'is only required when allow_mailing_address is set to true' do
      aid_application = build :aid_application, allow_mailing_address: false, mailing_city: ''
      expect(aid_application).to be_valid(:submit)
    end
  end

  describe '#mailing_state' do
    it 'is required' do
      aid_application = build :aid_application, mailing_state: ''
      expect(aid_application).not_to be_valid(:submit)
    end

    it 'is only required when allow_mailing_address is set to true' do
      aid_application = build :aid_application, allow_mailing_address: false, mailing_state: ''
      expect(aid_application).to be_valid(:submit)
    end
  end

  describe '#mailing_zip_code' do
    it 'must be 5 digits' do
      aid_application = build :aid_application, mailing_zip_code: '1234'
      expect(aid_application).not_to be_valid(:submit)
    end

    it 'can be outside of CA' do
      aid_application = build :aid_application, mailing_zip_code: '12345'
      expect(aid_application).to be_valid(:submit)
    end

    it 'is only required when allow_mailing_address is set to true' do
      aid_application = build :aid_application, allow_mailing_address: false, mailing_zip_code: ''
      expect(aid_application).to be_valid(:submit)
    end
  end

  describe '#phone_number' do
    it 'is required' do
      aid_application = build :aid_application, phone_number: ''
      expect(aid_application).not_to be_valid(:submit)
    end

    it 'must be a valid number' do
      aid_application = build :aid_application, phone_number: '111'
      expect(aid_application).not_to be_valid(:submit)
    end

    it 'allows intermediate characters' do
      aid_application = build :aid_application, phone_number: '+1-555-666.1234'
      expect(aid_application).to be_valid(:submit)
      expect(aid_application.phone_number).to eq '5556661234'
    end
  end

  describe '#email' do
    context 'email_consent is false' do
      it 'is not required' do
        aid_application = build :aid_application, email_consent: false, email: ''
        expect(aid_application).to be_valid(:submit)
      end
    end

    context 'email_consent is true' do
      it 'is required' do
        aid_application = build :aid_application, email_consent: true, email: ''
        expect(aid_application).not_to be_valid(:submit)
      end

      it 'must be valid' do
        aid_application = build :aid_application, email_consent: true, email: '@garbage'
        expect(aid_application).not_to be_valid(:submit)
      end
    end
  end

  describe 'sms_consent or email_consent must be true' do
    context 'neither sms_consent nor email_consent is true' do
      it 'is invalid' do
        aid_application = build :aid_application, sms_consent: false, email_consent: false
        expect(aid_application).not_to be_valid(:submit)
      end
    end

    context 'sms_consent is true' do
      it 'is valid' do
        aid_application = build :aid_application, sms_consent: true, email_consent: false
        expect(aid_application).to be_valid(:submit)
      end
    end

    context 'email_consent is true' do
      it 'is valid' do
        aid_application = build :aid_application, sms_consent: false, email_consent: true, email: 'e@example.com'
        expect(aid_application).to be_valid(:submit)
      end
    end
  end

  describe 'landline' do
    context 'is true' do
      it 'sets sms_consent to false' do
        aid_application = build :aid_application, sms_consent: true, landline: true
        aid_application.save
        expect(aid_application.reload.sms_consent).to eq false
      end
    end
  end

  describe '#receives_calfresh_or_calworks' do
    it 'is required' do
      aid_application = build :aid_application, receives_calfresh_or_calworks: nil
      expect(aid_application).not_to be_valid(:submit)
      expect(aid_application.errors[:receives_calfresh_or_calworks]).to be_present
    end

    it 'allows false' do
      aid_application = build :aid_application, receives_calfresh_or_calworks: false
      expect(aid_application).to be_valid(:submit)
    end
  end

  describe '#racial_ethnic_identity' do
    it 'is required' do
      aid_application = build :aid_application, racial_ethnic_identity: nil
      expect(aid_application).not_to be_valid(:submit)
      expect(aid_application.errors[:racial_ethnic_identity]).to be_present
    end
  end

  describe '#attestation' do
    it 'must be true' do
      aid_application = build :aid_application, attestation: nil
      expect(aid_application).not_to be_valid(:submit)
    end
  end

  describe '#no_cbo_association' do
    it 'must be true' do
      aid_application = build :aid_application, no_cbo_association: nil
      expect(aid_application).not_to be_valid(:eligibility)
    end
  end

  describe '#valid_work_authorization' do
    it 'must be false' do
      aid_application = build :aid_application, valid_work_authorization: true
      expect(aid_application).not_to be_valid(:eligibility)
    end
  end

  describe '#eligibility_required' do
    it 'must have at least one covid19 criteria checked' do
      aid_application = build :aid_application,
                                covid19_care_facility_closed: nil,
                                covid19_caregiver: nil,
                                covid19_experiencing_symptoms: nil,
                                covid19_reduced_work_hours: nil,
                                covid19_underlying_health_condition: nil
      expect(aid_application).not_to be_valid(:eligibility)
    end
  end

  describe '#county_name' do
    it "must be one of the organization's county_names" do
      aid_application = build :aid_application, county_name: "None of the above", organization: build(:organization, county_names: ["Alameda"])
      expect(aid_application).not_to be_valid(:eligibility)
    end
  end

  describe '#contact_method_confirmed' do
    it 'must be true' do
      aid_application = build :aid_application, contact_method_confirmed: nil
      expect(aid_application).not_to be_valid(:verification)
	end
  end

  describe '#card_receipt_method' do
    it 'is required' do
      aid_application = build :aid_application, card_receipt_method: nil
      expect(aid_application).not_to be_valid(:verification)
    end
  end

  describe '.query' do
    it 'performs a scoped query against associated AidApplicationSearch' do
      aid_application = create :aid_application, :submitted, city: 'Riverside'
      _other_aid_application = create :aid_application, :submitted, city:   'San Diego'

      AidApplicationSearch.refresh
      expect(described_class.query('Riverside')).to eq [aid_application]
    end
  end

  describe '.matching_submitted_apps' do
    context 'there are existing submitted apps with the same name, birthday, zip code and street address' do
      it 'returns the matching apps' do
        name = "Fake Name"
        birthday = 'January 1, 1980'
        zip_code = '12345'
        street_address = '123 Main St'
        aid_application = create :aid_application, :submitted, name: name, birthday: birthday, zip_code: zip_code, street_address: street_address
        duplicate_aid_application = create :aid_application, :submitted, name: name, birthday: birthday, zip_code: zip_code, street_address: street_address
        _unsubmitted_matching_aid_application = create :aid_application, name: name, birthday: birthday, zip_code: zip_code, street_address: street_address
        _submitted_street_address_does_not_match_aid_application = create :aid_application, :submitted, name: name, birthday: birthday, zip_code: zip_code, street_address: 'other street address'
        _submitted_name_does_not_match_aid_application = create :aid_application, :submitted, name: 'different name', birthday: birthday, zip_code: zip_code, street_address: street_address
        extra_white_space_in_fields_aid_application = create :aid_application, :submitted, name: "#{name}    ", birthday: birthday, zip_code: "#{zip_code}       ", street_address: " #{street_address}"

        expect(AidApplication.matching_submitted_apps(aid_application)).to eq [duplicate_aid_application, extra_white_space_in_fields_aid_application]
      end
    end
  end

  describe '#disburse' do
    let(:supervisor) { create :supervisor }
    let(:payment_card) { create :payment_card }
    let(:aid_application) { create :aid_application }

    it 'attaches itself the the aid application and generates an activation code' do
      aid_application.disburse(payment_card, disburser: supervisor)

      expect(payment_card.aid_application).to eq aid_application
      expect(payment_card.activation_code).to be_present
      expect(payment_card.activation_code.size).to eq 6
      expect(aid_application.payment_card).to eq payment_card
      expect(aid_application.disbursed_at).to be_within(1.second).of Time.current
      expect(aid_application.disburser).to eq supervisor
    end
  end

  describe '#save_and_submit' do
    let(:aid_application) { create :aid_application }

    it 'adds a submitted_at and submitter' do
      expect {
        aid_application.save_and_submit(submitter: aid_application.creator)
      }.to change { aid_application.reload.submitted_at }.from(nil).to within(1.second).of Time.current
      expect(aid_application.reload.submitter).to eq aid_application.creator
    end

    it 'generates a application_number' do
      expect {
        aid_application.save_and_submit(submitter: aid_application.creator)
      }.to change { aid_application.reload.application_number.present? }.from(false).to true
    end
  end

  describe '#save_and_approve' do
    let(:aid_application) { create :aid_application }

    it 'adds an approved_at' do
      expect {
        aid_application.save_and_approve(approver: aid_application.creator)
      }.to change { aid_application.reload.approved_at }.from(nil).to(within(1.second).of Time.current)
      expect(aid_application.reload.approver).to eq aid_application.creator

    end
  end

  describe '#application_number' do
    it 'cannot be changed once assigned' do
      aid_application = create :aid_application, :submitted
      expect do
        aid_application.update application_number: 'something else'
      end.not_to change { aid_application.reload.application_number }
    end
  end

  describe '#generate_unique_identifer' do
    let(:aid_application) { create :aid_application }

    it 'is in the shape of APP-[organization_id]-123-456' do
      expect(aid_application.generate_application_number).to match /APP-#{aid_application.organization.id}-\d{3}-\d{3}/
    end

    it 'cycles through values until it finds a valid one' do
      tried_values = []
      allow(described_class).to receive :exists? do |**args|
        tried_values << args[:application_number]
        tried_values.size < 4 ? true : false
      end

      aid_application.generate_application_number

      expect(tried_values.uniq.size).to eq 4
    end
  end

  describe '#send_submission_notification' do
    context 'when SMS consent' do
      let(:aid_application) { create :aid_application, :submitted, email_consent: false }

      it 'sends an SMS' do
        expect do
          aid_application.send_submission_notification
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationTexter", any_args).exactly(:twice)
      end
    end

    context 'when email consent' do
      let(:aid_application) { create :aid_application, :submitted, sms_consent: false }

      it 'sends an email' do
        expect do
          aid_application.send_submission_notification
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationEmailer", any_args)
      end
    end

    context 'when both consents' do
      let(:aid_application) { create :aid_application, :submitted }

      it 'sends both email and sms' do
        expect do
          aid_application.send_submission_notification
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationEmailer", any_args)
                 .and have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationTexter", any_args).exactly(:twice)
      end

    end
  end

  describe '#send_disbursement_notification' do
    context 'when SMS consent' do
      let(:aid_application) { create :aid_application, :disbursed, email_consent: false }

      it 'sends an SMS' do
        expect do
          aid_application.send_disbursement_notification
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationTexter", any_args)
      end
    end

    context 'when email consent' do
      let(:aid_application) { create :aid_application, :disbursed, sms_consent: false }

      it 'sends an email' do
        expect do
          aid_application.send_disbursement_notification
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationEmailer", any_args)
      end
    end

    context 'when both consents' do
      let(:aid_application) { create :aid_application, :disbursed }

      it 'sends both email and sms' do
        expect do
          aid_application.send_disbursement_notification
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationEmailer", any_args)
                 .and have_enqueued_job(ActionMailer::MailDeliveryJob).with("ApplicationTexter", any_args)
      end

    end
  end

  describe 'papertrail' do
    it 'tracks changes' do
      expect do
        aid_application.update name: "something else"
      end.to change { aid_application.reload.versions.count }.by(1)
    end
  end
end
