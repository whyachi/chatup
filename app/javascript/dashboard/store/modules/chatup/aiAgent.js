import types from './mutation-types';
import ChatupAiAgentAPI from '../../../api/chatup/aiAgent';

export const state = {
  config: {},
  uiFlags: {
    isFetching: false,
    isSaving: false,
  },
};

export const getters = {
  getUIFlags(_state) {
    return _state.uiFlags;
  },
  getConfig(_state) {
    return _state.config;
  },
};

export const actions = {
  fetchConfig: async ({ commit }) => {
    commit(types.SET_CHATUP_AI_AGENT_UI_FLAG, { isFetching: true });
    try {
      const response = await ChatupAiAgentAPI.getConfig();
      commit(types.SET_CHATUP_AI_AGENT_CONFIG, response.data);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.SET_CHATUP_AI_AGENT_UI_FLAG, { isFetching: false });
    }
  },
  saveConfig: async ({ commit }, configData) => {
    commit(types.SET_CHATUP_AI_AGENT_UI_FLAG, { isSaving: true });
    try {
      const response = await ChatupAiAgentAPI.updateConfig(configData);
      commit(types.SET_CHATUP_AI_AGENT_CONFIG, response.data);
      return response.data;
    } catch (error) {
      throw new Error(error?.response?.data?.message || error.message);
    } finally {
      commit(types.SET_CHATUP_AI_AGENT_UI_FLAG, { isSaving: false });
    }
  },
};

export const mutations = {
  [types.SET_CHATUP_AI_AGENT_UI_FLAG](_state, data) {
    _state.uiFlags = { ..._state.uiFlags, ...data };
  },
  [types.SET_CHATUP_AI_AGENT_CONFIG](_state, data) {
    _state.config = data;
  },
};

export default {
  namespaced: true,
  actions,
  state,
  getters,
  mutations,
};
