<template>
    <div id="searchBar" class="row justify-content-center">
        <div class="col-12 col-sm-12 col-md-8 col-lg-6">
            <form class="input-group">
            <a v-if="clearIsVisible" href="javascript:" aria-label="Clear search" id="btn-clear-input" @click.prevent="$emit('clearSearch')"><font-awesome-icon icon="circle-xmark"/></a>
            <input class="form-control form-control-lg" :placeholder="t('components.search_bar.placeholder')"  :value="modelValue" @input="$emit('update:modelValue', $event.target.value)">
            <input class="btn btn-primary" type="submit" @click.prevent="$emit('submitSearch')" :value="t('components.search_bar.submit')">
            </form>
        </div>
    </div>
</template>

<script setup>
const {t} = useI18n()
const props = defineProps(['modelValue'])
defineEmits(['update:modelValue', 'submitSearch', 'clearSearch'])  

const clearIsVisible = computed(() => { 
    if (props.modelValue && props.modelValue.length > 0) {
          return true;
    }
    return false;
})

</script>

<style lang="scss" scoped>
  #searchBar {
    margin-bottom: 40px;
    #btn-clear-input {
      position: absolute;
      top: 12px;
      right:90px;
      z-index: 100;
      color: black;
    }
  }
</style>