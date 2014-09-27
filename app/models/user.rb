class User < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  has_and_belongs_to_many :assessments, :class_name => "Assessment"
  belongs_to :daily_assessment, :class_name => "Assessment", :foreign_key => "daily_assessment_id"
  has_many :assessment_responses, dependent: :destroy

  acts_as_authentic do |c|
    c.login_field = 'email'
  end

  def todays_entry
    most_recent_entry = self.entries.sort_by(&:created_at).last
    if(most_recent_entry.nil? || most_recent_entry.created_at.to_date != Date.current)
      most_recent_entry = self.entries.create!()
    end
    return most_recent_entry
  end
end
