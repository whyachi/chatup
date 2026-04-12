import { FEATURE_FLAGS } from 'dashboard/featureFlags';
import { frontendURL } from '../../../../helper/URLHelper';
import Index from './Index.vue';

const meta = {
  permissions: ['administrator'],
  featureFlag: FEATURE_FLAGS.CHATUP_BOILERPLATE,
};

export const routes = [
  {
    path: frontendURL('accounts/:accountId/chatup-modules/boilerplate'),
    name: 'chatup_boilerplate_index',
    component: Index,
    meta,
  },
];
