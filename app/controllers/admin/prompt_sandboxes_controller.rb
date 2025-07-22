class Admin::PromptSandboxesController < AdminController
  include DayTimelinesScoped

  def show
    @prompt = cookies[:prompt].presence || Event::Summarizer::PROMPT
    @summary, @summarizable_content = summarize(@day_timeline, @prompt)
  end

  def create
    cookies[:prompt] = params[:prompt]
    day = Time.zone.parse(params[:day])
    redirect_to admin_prompt_sandbox_path(day: day.to_date)
  end

  private
    def summarize(day_timeline, prompt)
      summarizer = Event::Summarizer.new(day_timeline.events, prompt: prompt)
      summary = summarizer.summarize
      activity_summary = Event::ActivitySummary.new(content: summary)
      [ activity_summary.to_html, summarizer.summarizable_content.html_safe ]
    end
end
