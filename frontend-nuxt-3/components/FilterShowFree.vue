<template>
    <div>
        <div class="facet-filter">
            <div class="d-grid gap-2">
                <button role="button"  @click="$emit('update:modelValue', !modelValue)"  class="facet-header d-flex justify-content-between" :class="{active : modelValue}">
                    <span class="facet-header-text">{{t('components.freely_accessible_filter.label')}} </span>
                    <span class="facet-header-action-indicator">        
                        <span v-if="modelValue"><font-awesome-icon icon='square-check'/></span>
                        <span v-else><font-awesome-icon icon='fa-regular fa-square'/></span>   
                    </span>
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
  const {t} = useI18n();
  const props = defineProps(['modelValue'])
  defineEmits(['update:modelValue'])  
</script>

<style lang="scss" scoped>
    .facet-header {
    }

</style>