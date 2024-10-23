class Bubbles::StagingsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.toggle_stage Current.account.stages.find(params[:stage_id])
    redirect_to @bubble
  end
end
