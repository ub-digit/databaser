<template>
  <div class="database-view">
    <div class="row justify-content-end">
      <div class="col-auto m-4">
        <router-link
          v-if="isNewVisible"
          class="btn btn-light"
          :to="{ name: 'DatabaseNew' }"
          >New database +</router-link
        >
      </div>
    </div>
    <div class="row databases">
      <div class="row">
        <div class="col-3">
          <FormKit
            outer-class="database-filter mb-2"
            id="database_filter"
            type="text"
            :classes="{
              input: 'form-control',
            }"
            name="database_filter"
            v-model="searchTerm"
            placeholder="Search databases"
          >
            <template #prefix="context">
              <span class="search-icon">
                <font-awesome-icon icon="search" />
              </span>
            </template>
            <template #suffix="context">
              <a
                href="javascript:void()"
                class="resetBtn"
                v-if="isClearVisible"
                @click="resetSearch"
                ><font-awesome-icon icon="times"
              /></a>
            </template>
          </FormKit>

          <div class="form-check mb-4">
            <input
              class="form-check-input"
              type="checkbox"
              id="is-draft"
              v-model="onlyDrafts"
            />
            <label class="form-check-label" for="is-draft">Only drafts</label>
          </div>

          <ul v-if="databases && databases.length" class="left-nav">
            <li v-for="database in databases" :key="database.id">
              <router-link
                :to="{ name: 'DatabaseShow', params: { id: database.id } }"
                >{{ database.title_en }} </router-link
              ><span
                class="badge rounded-pill text-bg-light"
                v-if="!database.published"
              >
                Draft</span
              >
            </li>
            <button
              v-if="store.databases.length > numberOfDatabases"
              @click="showAll = showAll ? false : true"
              class="btn btn-primary"
            >
              <span v-if="!showAll">Show all</span><span v-else>Show less</span>
            </button>
          </ul>
          <div v-else-if="!loading">No database was found</div>
          <div v-else>loading...</div>
        </div>
        <div class="col-9">
          <router-view :key="$route.fullPath"></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useDatabasesStore } from "@/stores/databases";
import { search } from "@formkit/inputs";
import { computed, onMounted, ref, watch } from "vue";
import { useRoute } from "vue-router";
import _ from "lodash";

export default {
  name: "databases",
  setup() {
    const store = useDatabasesStore();
    const route = useRoute();
    const loading = ref(false);
    const searchTerm = ref("");
    const databases = null;
    const numberOfDatabases = 20;
    const showAll = ref(false);
    const onlyDrafts = ref(false);
    const fetchData = async () => {
      loading.value = true;
      const searchObj = { term: searchTerm.value };
      if (onlyDrafts.value) {
        searchObj.published = false;
      }
      const res = await store.fetchDatabases(searchObj);
      loading.value = false;
    };
    fetchData();
    watch(
      searchTerm,
      _.throttle(async () => {
        fetchData();
      }, 500)
    );
    watch(
      onlyDrafts,
      _.throttle(async () => {
        fetchData();
      }, 500)
    );
    watch(
      () => route.params,
      () => {
        fetchData();
      }
    );
    const resetSearch = () => {
      searchTerm.value = "";
    };
    onMounted(() => {
      const el = document.getElementById("database_filter").focus();
    });
    return {
      databases: computed(() => {
        if (store.databases) {
          if (showAll.value) {
            return store.databases;
          } else {
            return store.databases.slice(0, numberOfDatabases);
          }
        }
      }),
      loading,
      searchTerm,
      resetSearch,
      showAll,
      onlyDrafts,
      store,
      numberOfDatabases,
      isClearVisible: computed(() => {
        if (searchTerm.value.length) return true;
        return false;
      }),
      isNewVisible: computed(() => route.name != "DatabaseNew"),
    };
  },
};
</script>

<style lang="scss">
.database-view {
  h1 {
    margin-bottom: 40px;
  }
  .database-filter {
    position: relative;
    #database_filter {
      padding-left: 35px;
      padding-right: 35px;
    }

    .resetBtn {
      position: absolute;
      right: 10px;
      top: 7px;
    }
    .search-icon {
      position: absolute;
      left: 10px;
      top: 7px;
    }
  }
  a {
    text-decoration: none;
    &.router-link-active {
      text-decoration: underline;
    }
  }
}
</style>
