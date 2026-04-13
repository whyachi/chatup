import { FEATURE_FLAGS } from 'dashboard/featureFlags';
import { frontendURL } from '../../../../helper/URLHelper';
import Index from './Index.vue';

const meta = {
  permissions: ['administrator'],
  featureFlag: FEATURE_FLAGS.CHATUP_AI_AGENT,
};

export const routes = [
  {
    path: frontendURL('accounts/:accountId/chatup-modules/ai-agent'),
    name: 'chatup_ai_agent_index',
    component: Index,
    meta,
  },
];
