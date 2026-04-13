<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useI18n } from 'vue-i18n';
import { useAlert } from 'dashboard/composables';
import GeneralSettings from './tabs/GeneralSettings.vue';
import Behavior from './tabs/Behavior.vue';

const store = useStore();
const { t } = useI18n();

const activeTab = ref('general');
const tabs = [
  { key: 'general', label: 'CHATUP_AI_AGENT.TABS.GENERAL' },
  { key: 'behavior', label: 'CHATUP_AI_AGENT.TABS.BEHAVIOR' },
];

const config = computed(() => store.getters['chatupAiAgent/getConfig']);
const uiFlags = computed(() => store.getters['chatupAiAgent/getUIFlags']);

onMounted(() => {
  store.dispatch('chatupAiAgent/fetchConfig');
});

const onSave = async formData => {
  try {
    await store.dispatch('chatupAiAgent/saveConfig', formData);
    useAlert(t('CHATUP_AI_AGENT.SAVE_SUCCESS'));
  } catch (error) {
    useAlert(t('CHATUP_AI_AGENT.SAVE_ERROR'));
  }
};
</script>

<template>
  <div class="flex flex-col gap-4 p-6 overflow-y-auto">
    <div class="flex flex-col gap-1">
      <h1 class="text-2xl font-bold text-slate-800 dark:text-slate-100">
        {{ t('CHATUP_AI_AGENT.TITLE') }}
      </h1>
      <p class="text-sm text-slate-600 dark:text-slate-400">
        {{ t('CHATUP_AI_AGENT.SUBTITLE') }}
      </p>
    </div>

    <!-- Tabs -->
    <div class="flex gap-1 border-b border-slate-200 dark:border-slate-700">
      <button
        v-for="tab in tabs"
        :key="tab.key"
        class="px-4 py-2 text-sm font-medium transition-colors rounded-t-lg"
        :class="
          activeTab === tab.key
            ? 'bg-white dark:bg-slate-800 text-blue-600 border-b-2 border-blue-600'
            : 'text-slate-600 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200'
        "
        @click="activeTab = tab.key"
      >
        {{ t(tab.label) }}
      </button>
    </div>

    <!-- Loading -->
    <div
      v-if="uiFlags.isFetching"
      class="flex items-center justify-center py-12"
    >
      <span class="text-sm text-slate-500">
        {{ t('CHATUP_AI_AGENT.LOADING') }}
      </span>
    </div>

    <!-- Tab content -->
    <template v-else>
      <GeneralSettings
        v-if="activeTab === 'general'"
        :config="config"
        :is-saving="uiFlags.isSaving"
        @save="onSave"
      />
      <Behavior
        v-if="activeTab === 'behavior'"
        :config="config"
        :is-saving="uiFlags.isSaving"
        @save="onSave"
      />
    </template>
  </div>
</template>
