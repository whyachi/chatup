<script setup>
import { reactive, watch } from 'vue';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  config: { type: Object, default: () => ({}) },
  isSaving: { type: Boolean, default: false },
});

const emit = defineEmits(['save']);
const { t } = useI18n();

const form = reactive({
  business_name: '',
  business_phone: '',
  business_email: '',
  business_address: '',
  business_description: '',
});

watch(
  () => props.config,
  val => {
    if (val && val.configured) {
      form.business_name = val.business_name || '';
      form.business_phone = val.business_phone || '';
      form.business_email = val.business_email || '';
      form.business_address = val.business_address || '';
      form.business_description = val.business_description || '';
    }
  },
  { immediate: true }
);

const onSubmit = () => {
  emit('save', { ...form });
};
</script>

<template>
  <form class="flex flex-col gap-6 max-w-2xl" @submit.prevent="onSubmit">
    <!-- Business Name -->
    <div class="flex flex-col gap-1">
      <label class="text-sm font-medium text-slate-700 dark:text-slate-300">
        {{ t('CHATUP_AI_AGENT.GENERAL.BUSINESS_NAME') }}
      </label>
      <input
        v-model="form.business_name"
        type="text"
        class="w-full px-3 py-2 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        :placeholder="t('CHATUP_AI_AGENT.GENERAL.BUSINESS_NAME_PLACEHOLDER')"
        required
      />
    </div>

    <!-- Phone & Email row -->
    <div class="grid grid-cols-2 gap-4">
      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium text-slate-700 dark:text-slate-300">
          {{ t('CHATUP_AI_AGENT.GENERAL.PHONE') }}
        </label>
        <input
          v-model="form.business_phone"
          type="tel"
          class="w-full px-3 py-2 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          :placeholder="t('CHATUP_AI_AGENT.GENERAL.PHONE_PLACEHOLDER')"
        />
      </div>
      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium text-slate-700 dark:text-slate-300">
          {{ t('CHATUP_AI_AGENT.GENERAL.EMAIL') }}
        </label>
        <input
          v-model="form.business_email"
          type="email"
          class="w-full px-3 py-2 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          :placeholder="t('CHATUP_AI_AGENT.GENERAL.EMAIL_PLACEHOLDER')"
        />
      </div>
    </div>

    <!-- Address -->
    <div class="flex flex-col gap-1">
      <label class="text-sm font-medium text-slate-700 dark:text-slate-300">
        {{ t('CHATUP_AI_AGENT.GENERAL.ADDRESS') }}
      </label>
      <textarea
        v-model="form.business_address"
        rows="2"
        class="w-full px-3 py-2 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
        :placeholder="t('CHATUP_AI_AGENT.GENERAL.ADDRESS_PLACEHOLDER')"
      />
    </div>

    <!-- Description / Mission / Vision -->
    <div class="flex flex-col gap-1">
      <label class="text-sm font-medium text-slate-700 dark:text-slate-300">
        {{ t('CHATUP_AI_AGENT.GENERAL.DESCRIPTION') }}
      </label>
      <p class="text-xs text-slate-500 dark:text-slate-400">
        {{ t('CHATUP_AI_AGENT.GENERAL.DESCRIPTION_HELP') }}
      </p>
      <textarea
        v-model="form.business_description"
        rows="5"
        class="w-full px-3 py-2 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-y"
        :placeholder="t('CHATUP_AI_AGENT.GENERAL.DESCRIPTION_PLACEHOLDER')"
      />
    </div>

    <!-- Save button -->
    <div class="flex justify-end">
      <button
        type="submit"
        :disabled="isSaving || !form.business_name"
        class="px-6 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
      >
        {{ isSaving ? t('CHATUP_AI_AGENT.SAVING') : t('CHATUP_AI_AGENT.SAVE') }}
      </button>
    </div>
  </form>
</template>
