<script setup>
import { computed, onMounted } from 'vue';
import { useStore } from 'dashboard/composables/store';
import { useI18n } from 'vue-i18n';

const store = useStore();
const { t } = useI18n();

const items = computed(() => store.getters['chatupBoilerplate/getRecords']);
const uiFlags = computed(() => store.getters['chatupBoilerplate/getUIFlags']);

onMounted(() => {
  store.dispatch('chatupBoilerplate/get');
});

const addSample = async () => {
  const name = window.prompt(t('CHATUP_BOILERPLATE.PROMPT_NAME'));
  if (!name) return;
  try {
    await store.dispatch('chatupBoilerplate/create', { name, data: {} });
  } catch (error) {
    window.alert(error.message);
  }
};

const removeItem = async id => {
  if (!window.confirm(t('CHATUP_BOILERPLATE.CONFIRM_DELETE'))) return;
  await store.dispatch('chatupBoilerplate/delete', id);
};
</script>

<template>
  <div class="flex flex-col flex-1 overflow-auto p-6 gap-4">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-xl font-semibold text-n-slate-12">
          {{ t('CHATUP_BOILERPLATE.TITLE') }}
        </h1>
        <p class="text-sm text-n-slate-11">
          {{ t('CHATUP_BOILERPLATE.SUBTITLE') }}
        </p>
      </div>
      <button
        class="inline-flex items-center px-3 py-2 rounded-md bg-n-brand text-white text-sm font-medium hover:bg-n-brand/90 disabled:opacity-50"
        :disabled="uiFlags.isCreating"
        @click="addSample"
      >
        {{ t('CHATUP_BOILERPLATE.ADD') }}
      </button>
    </div>

    <div
      v-if="uiFlags.isFetching"
      class="text-sm text-n-slate-11"
    >
      {{ t('CHATUP_BOILERPLATE.LOADING') }}
    </div>

    <div
      v-else-if="!items.length"
      class="flex items-center justify-center h-40 rounded-lg border border-dashed border-n-slate-6 text-n-slate-11 text-sm"
    >
      {{ t('CHATUP_BOILERPLATE.EMPTY') }}
    </div>

    <ul
      v-else
      class="flex flex-col gap-2"
    >
      <li
        v-for="item in items"
        :key="item.id"
        class="flex items-center justify-between px-4 py-3 rounded-md bg-n-slate-2 border border-n-slate-4"
      >
        <span class="text-sm text-n-slate-12">{{ item.name }}</span>
        <button
          class="text-xs text-n-ruby-9 hover:underline"
          @click="removeItem(item.id)"
        >
          {{ t('CHATUP_BOILERPLATE.DELETE') }}
        </button>
      </li>
    </ul>
  </div>
</template>
