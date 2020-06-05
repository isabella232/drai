# == Schema Information
#
# Table name: organizations
#
#  id                        :bigint           not null, primary key
#  aid_applications_count    :integer          default(0), not null
#  county_names              :string           default([]), is an Array
#  name                      :text             not null
#  total_payment_cards_count :integer          default(0), not null
#  users_count               :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class Organization < ApplicationRecord
  has_paper_trail

  has_many :users
  has_many :supervisors, -> { supervisor }, class_name: 'User'
  has_many :aid_applications

  scope :with_counts, lambda {
    select <<~SQL
      organizations.*,
      (
        SELECT COUNT(aid_applications.id)
        FROM aid_applications
        WHERE
          organization_id = organizations.id
          AND submitted_at IS NOT NULL
          AND paused_at IS NULL
          AND rejected_at IS NULL
      ) AS total_aid_applications_count,
      (
        SELECT COUNT(aid_applications.id)
        FROM aid_applications
        WHERE
          organization_id = organizations.id 
          AND submitted_at IS NOT NULL
          AND paused_at IS NULL
          AND approved_at IS NULL
          AND rejected_at IS NULL
      ) AS submitted_aid_applications_count,
      (
        SELECT COUNT(aid_applications.id)
        FROM aid_applications
        WHERE
          organization_id = organizations.id
          AND paused_at IS NOT NULL
          AND rejected_at IS NULL
      ) AS paused_aid_applications_count,
      (
        SELECT COUNT(aid_applications.id)
        FROM aid_applications
        WHERE
          organization_id = organizations.id
          AND approved_at IS NOT NULL
          AND disbursed_at IS NULL
          AND rejected_at IS NULL
      ) AS approved_aid_applications_count,
      (
        SELECT COUNT(aid_applications.id)
        FROM aid_applications
        WHERE
          organization_id = organizations.id
          AND disbursed_at IS NOT NULL
      ) AS disbursed_aid_applications_count,
      (
        SELECT COUNT(aid_applications.id)
        FROM aid_applications
        WHERE
          organization_id = organizations.id 
          AND rejected_at IS NOT NULL
      ) AS rejected_aid_applications_count
    SQL
  }

  def total_aid_applications_count
    @total_aid_applications_count ||= attributes["total_aid_applications_count"] || aid_applications.submitted.count
  end

  [:submitted, :approved, :disbursed, :paused, :rejected].each do |status|
    class_eval <<~RUBY
      def #{status}_aid_applications_count
        @#{status}_aid_applications_count ||= attributes["#{status}_aid_applications_count"] || aid_applications.only_#{status}.count
      end
    RUBY
  end

  def counts_by_county
    return @_counts_by_county if @_counts_by_county

    raw_counts = {
      total: aid_applications.submitted.group(:county_name).count,
      submitted: aid_applications.only_submitted.group(:county_name).count,
      approved: aid_applications.only_approved.group(:county_name).count,
      disbursed: aid_applications.only_disbursed.group(:county_name).count,
      paused: aid_applications.only_paused.group(:county_name).count,
      rejected: aid_applications.only_rejected.group(:county_name).count,
    }

    by_counties = {}
    raw_counts.each do |type, counties|
      counties.each do |county, count|
        by_counties[county] ||= {}
        by_counties[county][type] = count
      end
    end

    # Zero out any missing types
    by_counties.each do |_county, counts|
      raw_counts.each do |type, _|
        counts[type] ||= 0
      end
    end

    @_counts_by_county = by_counties.sort.to_h
  end
end
