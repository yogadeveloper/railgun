class ConvertAttachmentToPolymorphic2 < ActiveRecord::Migration
  def change
    remove_index :attachments, :attachable_type
    remove_index :attachments, :attachable_id
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
