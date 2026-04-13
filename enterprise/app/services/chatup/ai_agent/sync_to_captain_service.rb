class Chatup::AiAgent::SyncToCaptainService
  TONE_GUIDELINES = {
    'professional' => 'Always respond in a professional and formal tone. Use polite language and proper grammar.',
    'friendly' => 'Respond in a warm, friendly and approachable tone. Be conversational but helpful.',
    'casual' => 'Use a casual, relaxed tone. Keep responses short and informal.'
  }.freeze

  def initialize(ai_agent)
    @ai_agent = ai_agent
    @assistant = ai_agent.captain_assistant
  end

  def perform
    @assistant.update!(
      name: @ai_agent.business_name,
      description: build_description,
      response_guidelines: build_response_guidelines,
      guardrails: build_guardrails,
      config: build_config
    )
  end

  private

  def build_description
    parts = []
    parts << "Business Name: #{@ai_agent.business_name}" if @ai_agent.business_name.present?
    parts << "Description: #{@ai_agent.business_description}" if @ai_agent.business_description.present?
    parts << "Address: #{@ai_agent.business_address}" if @ai_agent.business_address.present?
    parts << "Phone: #{@ai_agent.business_phone}" if @ai_agent.business_phone.present?
    parts << "Email: #{@ai_agent.business_email}" if @ai_agent.business_email.present?

    if @ai_agent.working_hours.present? && @ai_agent.working_hours.any? { |_day, config| config['enabled'] }
      hours_text = build_working_hours_text
      parts << "Working Hours: #{hours_text}" if hours_text.present?
    end

    parts.join("\n\n")
  end

  def build_response_guidelines
    guidelines = []

    # Tone
    tone = @ai_agent.tone.presence || 'professional'
    guidelines << TONE_GUIDELINES[tone] if TONE_GUIDELINES[tone]

    # Language
    language = @ai_agent.language.presence || 'tr'
    language_name = language_display_name(language)
    guidelines << "Always respond in #{language_name}."

    # Greeting
    if @ai_agent.auto_greet == true || @ai_agent.auto_greet == 'true'
      greeting = @ai_agent.greeting_message.presence || 'Hello! How can I help you?'
      guidelines << "When a customer starts a new conversation, greet them with: \"#{greeting}\""
    end

    # Contact info collection
    if @ai_agent.collect_contact_info == true || @ai_agent.collect_contact_info == 'true'
      guidelines << 'If the customer has not provided their name and email, politely ask for their contact information early in the conversation.'
    end

    # Product recommendations
    if @ai_agent.product_recommendations == true || @ai_agent.product_recommendations == 'true'
      guidelines << 'When relevant, recommend products or services from the business catalog that match the customer needs.'
    end

    # Out of hours
    if @ai_agent.out_of_hours_reply == true || @ai_agent.out_of_hours_reply == 'true'
      ooh_msg = @ai_agent.out_of_hours_message.presence || 'We are currently outside of working hours. We will get back to you as soon as possible.'
      guidelines << "Outside of working hours, inform the customer: \"#{ooh_msg}\""
    end

    guidelines
  end

  def build_guardrails
    guardrails = []

    if @ai_agent.auto_handoff == true || @ai_agent.auto_handoff == 'true'
      handoff_msg = @ai_agent.handoff_message.presence || 'Let me connect you with a team member who can help you better.'
      guardrails << "If you cannot answer a question confidently or the customer explicitly asks for a human agent, hand off the conversation. Use this message: \"#{handoff_msg}\""
    end

    guardrails << 'Never make up information. If you do not have enough information to answer, say so honestly.'
    guardrails << 'Do not discuss competitors or make comparisons with other businesses.'
    guardrails << 'Never share internal business information, pricing strategies, or confidential data.'

    guardrails
  end

  def build_config
    existing = @assistant.config || {}
    existing.merge(
      'product_name' => @ai_agent.business_name,
      'temperature' => existing['temperature'] || 0.7
    )
  end

  def build_working_hours_text
    days = %w[monday tuesday wednesday thursday friday saturday sunday]
    hours = @ai_agent.working_hours

    active_days = days.select { |d| hours.dig(d, 'enabled') }
    return nil if active_days.empty?

    active_days.map { |d| "#{d.capitalize}: #{hours[d]['start']} - #{hours[d]['end']}" }.join(', ')
  end

  def language_display_name(code)
    {
      'tr' => 'Turkish',
      'en' => 'English',
      'de' => 'German',
      'fr' => 'French',
      'es' => 'Spanish',
      'ar' => 'Arabic',
      'nl' => 'Dutch'
    }[code] || code
  end
end
