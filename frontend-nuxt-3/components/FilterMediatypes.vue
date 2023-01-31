<template>
<div>
    <div class="facet-filter" v-if="mediatypes.length > 0">
      <div class="d-grid gap-2">
          <button v-if="filters.mediatype" role="button" class="facet-header d-flex justify-content-between" :class="{active: filters.mediatype}" @click="$emit('setMediatype', undefined)" >
              <span class="facet-header-text">
                {{selectedMediatypeFull.name}}
              </span>
              <span class="facet-header-action-indicator"
                  ><font-awesome-icon icon="xmark"
              /></span>
          </button>
          <button v-else role="button" class="facet-header d-flex justify-content-between" @click="toggleMediatypeExpanded()" >
              <span class="facet-header-text">{{t('components.mediatype_filter.label')}}</span>
              <span class="facet-header-action-indicator">
                  <font-awesome-icon v-if="isOpen" icon="chevron-up"/>
                  <font-awesome-icon v-else icon="chevron-down"/>
              </span>
          </button>
      </div>
      <ul class="list-unstyled mediatype-list" v-if="isOpen">
          <li v-for="mediatype in mediatypes" :key="mediatype.id">
              <a href="javascript:" @click.prevent="$emit('setMediatype', mediatype.id)">
                  {{ mediatype.name }}
              </a> ({{mediatype.count}})
          </li>
      </ul>
    </div>
</div>
</template>

<script setup>
const {t} = useI18n();
const props = defineProps(['filters','mediatypes'])
defineEmits(['setMediatype'])
const isOpen = ref(false);

const toggleMediatypeExpanded = () => {
    isOpen.value = !isOpen.value;
}

watch(() => props.filters.mediatype, (before, after) => {
  if (props.filters.mediatype) {
    isOpen.value = false;
  }
})

const selectedMediatypeFull = computed(() => {
    if (props.filters.mediatype) {
        return props.mediatypes.find((mediatype) => props.filters.mediatype === mediatype.id);
    }
})


</script>

<style lang="scss" scoped>

    ul {
    &.mediatype-list  {
        padding: 5px 10px;
        li {
            padding-bottom: 10px;
            &:last-child {
            padding-bottom: 0;
            }
        }
    }
}

</style>