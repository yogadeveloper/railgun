require 'rails_helper'

describe Answer do
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should validate_presence_of(:question_id) }
  it { should belong_to :question }
end