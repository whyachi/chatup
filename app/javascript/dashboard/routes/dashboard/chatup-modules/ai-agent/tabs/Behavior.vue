<script setup>
import { reactive, watch } from 'vue';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  config: { type: Object, default: () => ({}) },
  isSaving: { type: Boolean, default: false },
});

const emit = defineEmits(['save']);
const { t } = useI18n();

const TONE_OPTIONS = [
  { value: 'professional', label: 'CHATUP_AI_AGENT.BEHAVIOR.TONE_PROFESSIONAL' },
  { value: 'friendly', label: 'CHATUP_AI_AGENT.BEHAVIOR.TONE_FRIENDLY' },
  { value: 'casual', label: 'CHATUP_AI_AGENT.BEHAVIOR.TONE_CASUAL' },
];

const LANGUAGE_OPTIONS = [
  { value: 'tr', label: 'Türkçe' },
  { value: 'en', label: 'English' },
  { value: 'de', label: 'Deutsch' },
  { value: 'fr', label: 'Français' },
  { value: 'es', label: 'Español' },
  { value: 'ar', label: 'العربية' },
  { value: 'nl', label: 'Nederlands' },
];

const form = reactive({
  tone: 'professional',
  language: 'tr',
  auto_greet: false,
  greeting_message: '',
  auto_handoff: true,
  handoff_message: '',
  out_of_hours_reply: false,
  out_of_hours_message: '',
  collect_contact_info: false,
  product_recommendations: false,
});

watch(
  () => props.config,
  val => {
    if (val && val.behavior) {
      const b = val.behavior;
      form.tone = b.tone || 'professional';
      form.language = b.language || 'tr';
      form.auto_greet = b.auto_greet === true || b.auto_greet === 'true';
      form.greeting_message = b.greeting_message || '';
      form.auto_handoff = b.auto_handoff !== false && b.auto_handoff !== 'false';
      form.handoff_message = b.handoff_message || '';
      form.out_of_hours_reply =
        b.out_of_hours_reply === true || b.out_of_hours_reply === 'true';
      form.out_of_hours_message = b.out_of_hours_message || '';
      form.collect_contact_info =
        b.collect_contact_info === true || b.collect_contact_info === 'true';
      form.product_recommendations =
        b.product_recommendations === true ||
        b.product_recommendations === 'true';
    }
  },
  { immediate: true }
);

const onSubmit = () => {
  emit('save', { behavior: { ...form } });
};
</script>

<template>
  <form class="flex flex-col gap-6 max-w-2xl" @submit.prevent="onSubmit">
    <!-- Tone -->
    <div class="flex flex-col gap-1">
      <label class="text-sm font-medium text-slate-700 dark:text-slate-300">
        {{ t('CHATUP_AI_AGENT.BEHAVIOR.TONE') }}
      </label>
      <select
        v-model="form.tone"
        class="w-full px-3 py-2 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500"
      >
        <option
          v-for="opt in TONE_OPTIONS"
          :key="opt.value"
          :value="opt.value"
        >
          {{ t(opt.label) }}
        </option>
      </select>
    </div>

    <!-- Language -->
    <div class="flex flex-col gap-1">
      <label class="text-sm font-medium text-slate-700 dark:text-slate-300">
        {{ t('CHATUP_AI_AGENT.BEHAVIOR.LANGUAGE') }}
      </label>
      <select
        v-model="form.language"
        class="w-full px-3 py-2 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500"
      >
        <option
          v-for="opt in LANGUAGE_OPTIONS"
          :key="opt.value"
          :value="opt.value"
        >
          {{ opt.label }}
        </option>
      </select>
    </div>

    <!-- Auto Greet -->
    <div class="flex flex-col gap-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800/50">
      <label class="flex items-center gap-3 cursor-pointer">
        <input
          v-model="form.auto_greet"
          type="checkbox"
          class="w-4 h-4 text-blue-600 rounded border-slate-300 focus:ring-blue-500"
        />
        <span class="text-sm font-medium text-slate-700 dark:text-slate-300">
          {{ t('CHATUP_AI_AGENT.BEHAVIOR.AUTO_GREET') }}
        </span>
      </label>
      <p class="text-xs text-slate-500 ml-7">
        {{ t('CHATUP_AI_AGENT.BEHAVIOR.AUTO_GREET_HELP') }}
      </p>
      <textarea
        v-if="form.auto_greet"
        v-model="form.greeting_message"
        rows="2"
        class="w-full px-3 py-2 mt-1 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 resize-none"
        :placeholder="t('CHATUP_AI_AGENT.BEHAVIOR.GREETING_PLACEHOLDER')"
      />
    </div>

    <!-- Auto Handoff -->
    <div class="flex flex-col gap-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800/50">
      <label class="flex items-center gap-3 cursor-pointer">
        <input
          v-model="form.auto_handoff"
          type="checkbox"
          class="w-4 h-4 text-blue-600 rounded border-slate-300 focus:ring-blue-500"
        />
        <span class="text-sm font-medium text-slate-700 dark:text-slate-300">
          {{ t('CHATUP_AI_AGENT.BEHAVIOR.AUTO_HANDOFF') }}
        </span>
      </label>
      <p class="text-xs text-slate-500 ml-7">
        {{ t('CHATUP_AI_AGENT.BEHAVIOR.AUTO_HANDOFF_HELP') }}
      </p>
      <textarea
        v-if="form.auto_handoff"
        v-model="form.handoff_message"
        rows="2"
        class="w-full px-3 py-2 mt-1 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 resize-none"
        :placeholder="t('CHATUP_AI_AGENT.BEHAVIOR.HANDOFF_PLACEHOLDER')"
      />
    </div>

    <!-- Out of Hours Reply -->
    <div class="flex flex-col gap-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800/50">
      <label class="flex items-center gap-3 cursor-pointer">
        <input
          v-model="form.out_of_hours_reply"
          type="checkbox"
          class="w-4 h-4 text-blue-600 rounded border-slate-300 focus:ring-blue-500"
        />
        <span class="text-sm font-medium text-slate-700 dark:text-slate-300">
          {{ t('CHATUP_AI_AGENT.BEHAVIOR.OUT_OF_HOURS') }}
        </span>
      </label>
      <p class="text-xs text-slate-500 ml-7">
        {{ t('CHATUP_AI_AGENT.BEHAVIOR.OUT_OF_HOURS_HELP') }}
      </p>
      <textarea
        v-if="form.out_of_hours_reply"
        v-model="form.out_of_hours_message"
        rows="2"
        class="w-full px-3 py-2 mt-1 border rounded-lg border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 resize-none"
        :placeholder="t('CHATUP_AI_AGENT.BEHAVIOR.OUT_OF_HOURS_PLACEHOLDER')"
      />
    </div>

    <!-- Collect Contact Info -->
    <div class="flex flex-col gap-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800/50">
      <label class="flex items-center gap-3 cursor-pointer">
        <input
          v-model="form.collect_contact_info"
          type="checkbox"
          class="w-4 h-4 text-blue-600 rounded border-slate-300 focus:ring-blue-500"
        />
        <span class="text-sm font-medium text-slate-700 dark:text-slate-300">
          {{ t('CHATUP_AI_AGENT.BEHAVIOR.COLLECT_CONTACT') }}
        </span>
      </label>
      <p class="text-xs text-slate-500 ml-7">
        {{ t('CHATUP_AI_AGENT.BEHAVIOR.COLLECT_CONTACT_HELP') }}
      </p>
    </div>

    <!-- Product Recommendations -->
    <div class="flex flex-col gap-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800/50">
      <label class="flex items-center gap-3 cursor-pointer">
        <input
          v-model="form.product_recommendations"
          type="checkbox"
          class="w-4 h-4 text-blue-600 rounded border-slate-300 focus:ring-blue-500"
        />
        <span class="text-sm font-medium text-slate-700 dark:text-slate-300">
          {{ t('CHATUP_AI_AGENT.BEHAVIOR.PRODUCT_RECOMMENDATIONS') }}
        </span>
      </label>
      <p class="text-xs text-slate-500 ml-7">
        {{ t('CHATUP_AI_AGENT.BEHAVIOR.PRODUCT_RECOMMENDATIONS_HELP') }}
      </p>
    </div>

    <!-- Save button -->
    <div class="flex justify-end">
      <button
        type="submit"
        :disabled="isSaving"
        class="px-6 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
      >
        {{
          isSaving ? t('CHATUP_AI_AGENT.SAVING') : t('CHATUP_AI_AGENT.SAVE')
        }}
      </button>
    </div>
  </form>
</template>
