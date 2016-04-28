require 'rails_helper'

describe Question do
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(40) }
  it { should validate_presence_of(:title) }
  it { should have_many(:answers).dependent(:destroy) }

end