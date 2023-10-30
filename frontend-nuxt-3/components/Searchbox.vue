<template>
  <div id="searchBar" class="row justify-content-center">
    <div class="col-12 col-sm-12 col-md-8 col-lg-6">
      <form class="input-group">
        <a
          v-if="clearIsVisible"
          href="#"
          aria-label="Clear search"
          id="btn-clear-input"
          @click.prevent="clearSearch"
          ><font-awesome-icon icon="circle-xmark"
        /></a>
        <input
          class="form-control form-control-lg"
          :placeholder="t('components.search_bar.placeholder')"
          v-model="localSearchStr"
        />
        <input
          class="btn btn-primary"
          type="submit"
          @click.prevent="submitSearch(localSearchStr)"
          :value="t('components.search_bar.submit')"
        />
      </form>
      <div
        tabindex="-1"
        style="
          position: absolute;
          z-index: 100;
          max-height: 200px;
          overflow-y: scroll;
        "
      >
        <ul v-if="dbs.data" class="list-group">
          <li class="list-group-item" v-for="db in dbs.data" :key="db.id">
            <LangLink
              class="database-link"
              :to="`/${db.sanitized_title}/${db.id}`"
              >{{ db.title }}
              <font-awesome-icon class="fa-xs" icon="arrow-right" /></LangLink
            >&nbsp;
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useDebounceFn } from "@vueuse/core";

const { t, getLocale } = useI18n();
const dbs = ref({});
const props = defineProps(["searchStr"]);
const localSearchStr = ref(props.searchStr);
const autoCompleteIsCanceled = ref(false);
const emit = defineEmits(["submitSearch", "clearSearch", "updateSearchStr"]);

// throttle input
const debouncedFn = useDebounceFn(async () => {
  if (localSearchStr.value === "") {
    dbs.value = {};
    return;
  }
  try {
    const {
      data: databases,
      pending,
      error,
      refresh,
    } = await useFetch("/api/databases", {
      params: { search: localSearchStr.value, lang: getLocale() },
    });
    if (autoCompleteIsCanceled.value) {
      dbs.value = {};
    } else {
      dbs.value = databases.value;
    }
  } catch (error) {
    console.log(error);
  }
}, 500);

watch(localSearchStr, () => {
  emit("updateSearchStr", localSearchStr);
  debouncedFn();
  autoCompleteIsCanceled.value = false;
});

const clearIsVisible = computed(() => {
  if (localSearchStr.value && localSearchStr.value.length > 0) {
    return true;
  }
  return false;
});

function submitSearch(searchStr) {
  dbs.value = {};
  autoCompleteIsCanceled.value = true;
  emit("submitSearch", searchStr);
}

function clearSearch() {
  localSearchStr.value = "";
  emit("clearSearch");
}
</script>

<style lang="scss" scoped>
#searchBar {
  margin-bottom: 40px;
  #btn-clear-input {
    position: absolute;
    top: 12px;
    right: 90px;
    z-index: 100;
    color: black;
  }
}
</style>
