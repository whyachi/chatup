import * as MutationHelpers from 'shared/helpers/vuex/mutationHelpers';
import types from './mutation-types';
import ChatupBoilerplateAPI from '../../../api/chatup/boilerplate';

export const state = {
  records: [],
  uiFlags: {
    isFetching: false,
    isCreating: false,
    isUpdating: false,
    isDeleting: false,
  },
};

export const getters = {
  getUIFlags(_state) {
    return _state.uiFlags;
  },
  getRecords(_state) {
    return _state.records;
  },
};

export const actions = {
  get: async ({ commit }) => {
    commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isFetching: true });
    try {
      const response = await ChatupBoilerplateAPI.get();
      commit(types.SET_CHATUP_BOILERPLATE_ITEMS, response.data);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isFetching: false });
    }
  },
  create: async ({ commit }, itemObj) => {
    commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isCreating: true });
    try {
      const response = await ChatupBoilerplateAPI.create({
        boilerplate_item: itemObj,
      });
      commit(types.CREATE_CHATUP_BOILERPLATE_ITEM, response.data);
    } catch (error) {
      throw new Error(error?.response?.data?.message || error.message);
    } finally {
      commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isCreating: false });
    }
  },
  update: async ({ commit }, { id, ...updateObj }) => {
    commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isUpdating: true });
    try {
      const response = await ChatupBoilerplateAPI.update(id, {
        boilerplate_item: updateObj,
      });
      commit(types.EDIT_CHATUP_BOILERPLATE_ITEM, response.data);
    } catch (error) {
      throw new Error(error?.response?.data?.message || error.message);
    } finally {
      commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isUpdating: false });
    }
  },
  delete: async ({ commit }, id) => {
    commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isDeleting: true });
    try {
      await ChatupBoilerplateAPI.delete(id);
      commit(types.DELETE_CHATUP_BOILERPLATE_ITEM, id);
    } catch (error) {
      throw new Error(error?.response?.data?.message || error.message);
    } finally {
      commit(types.SET_CHATUP_BOILERPLATE_UI_FLAG, { isDeleting: false });
    }
  },
};

export const mutations = {
  [types.SET_CHATUP_BOILERPLATE_UI_FLAG](_state, data) {
    _state.uiFlags = { ..._state.uiFlags, ...data };
  },
  [types.SET_CHATUP_BOILERPLATE_ITEMS]: MutationHelpers.set,
  [types.CREATE_CHATUP_BOILERPLATE_ITEM]: MutationHelpers.create,
  [types.EDIT_CHATUP_BOILERPLATE_ITEM]: MutationHelpers.update,
  [types.DELETE_CHATUP_BOILERPLATE_ITEM]: MutationHelpers.destroy,
};

export default {
  namespaced: true,
  actions,
  state,
  getters,
  mutations,
};
