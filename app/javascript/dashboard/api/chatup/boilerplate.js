import ApiClient from '../ApiClient';

class ChatupBoilerplateAPI extends ApiClient {
  constructor() {
    super('chatup/boilerplate_items', {
      accountScoped: true,
      apiVersion: 'v2',
    });
  }
}

export default new ChatupBoilerplateAPI();
