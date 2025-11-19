class Events::DayTimeline::ColumnsController < ApplicationController
  include DayTimelinesScoped

  def show
    @column = column_for_id(params[:id])
    fresh_when @day_timeline
  end

  private
    def column_for_id(id)
      case id.to_s.downcase
      when "added", "1"
        @day_timeline.added_column
      when "updated", "2"
        @day_timeline.updated_column
      when "closed", "3"
        @day_timeline.closed_column
      else
        head :not_found
      end
    end
end
