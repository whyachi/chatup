class Api::V2::Accounts::Chatup::AiAgentsController < Api::V1::Accounts::BaseController
  before_action -> { check_authorization(Chatup::AiAgent) }

  def show
    @ai_agent = find_or_initialize_ai_agent
    render json: ai_agent_response(@ai_agent)
  end

  def update
    @ai_agent = find_or_initialize_ai_agent
    @ai_agent.assign_attributes(ai_agent_params)
    if @ai_agent.save
      render json: ai_agent_response(@ai_agent)
    else
      render json: { error: @ai_agent.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def find_or_initialize_ai_agent
    Current.account.chatup_ai_agent || Current.account.build_chatup_ai_agent
  end

  def ai_agent_params
    params.require(:ai_agent).permit(
      :business_name, :business_phone, :business_email,
      :business_address, :business_description,
      working_hours: {},
      behavior: {}
    )
  end

  def ai_agent_response(agent)
    return { configured: false } unless agent.persisted?

    {
      configured: true,
      id: agent.id,
      business_name: agent.business_name,
      business_phone: agent.business_phone,
      business_email: agent.business_email,
      business_address: agent.business_address,
      business_description: agent.business_description,
      working_hours: agent.working_hours,
      behavior: agent.behavior,
      created_at: agent.created_at,
      updated_at: agent.updated_at
    }
  end
end
