class AddAnswerForeignKey < ActiveRecord::Migration
  def change
    add_belongs_to :answers, :questions, index: true, foreign_key: true
  end
end
