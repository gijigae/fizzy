class AddAssignerToAssignments < ActiveRecord::Migration[8.0]
  def change
    add_column :assignments, :assigner_id, :integer
    execute "update assignments set assigner_id = assignee_id"
    change_column_null :assignments, :assigner_id, false
  end
end
