import ApiClient from '../ApiClient';

class ChatupAiAgentAPI extends ApiClient {
  constructor() {
    super('chatup/ai_agent', {
      accountScoped: true,
      apiVersion: 'v2',
    });
  }

  getConfig() {
    return window.axios.get(this.url);
  }

  updateConfig(data) {
    return window.axios.put(this.url, { ai_agent: data });
  }
}

export default new ChatupAiAgentAPI();
