require 'rails_helper'

describe Account::SetupsController do
  let(:user) { create :user, :unsetup }

  describe '#edit' do
    context 'when authenticated' do
      before { sign_in user }

      it 'renders out a form for the current user' do
        get :edit
        expect(response).to have_http_status :ok
      end
    end

    context 'when unauthenticated' do
      it "redirects away" do
        get :edit
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when account already setup' do
      let(:user) { FactoryBot.create :user }

      it "redirects away" do
        sign_in user
        get :edit
        expect(response).to redirect_to account_path
      end
    end
  end

  describe '#update' do
    before { sign_in user }

    it 'saves the users password' do
      put :update, params: { user: { password: 'Otherpassword@3' } }

      expect(user.reload.password_present?).to be true
      expect(response).to redirect_to organization_dashboard_path(user.organization)
    end
  end
end
