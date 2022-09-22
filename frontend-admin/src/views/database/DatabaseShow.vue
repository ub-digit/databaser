<template>
  <div v-if="error">
    <h1>{{error}}</h1> 
  </div>
  <div v-else>
    <div v-if="database && database.id" class="databaseshow-wrapper">
        <div class="row pb-4">
            <div class="col">
              <h1>{{database.title_en}} / {{database.title_sv}}</h1>
            </div>
        </div>
        <div class="row pb-4">
          <div class="col">
            <label class="db-property-header fw-bold" for="desc_en">Description (en)</label>
            <div id="desc_en" v-html="desc_en_markdown_output"></div>
          </div>
          <div class="col">
            <label class="db-property-header fw-bold" for="desc_en">Description (sv)</label>
            <div id="desc_sv" v-html="desc_sv_markdown_output"></div>
          </div>
        </div>
        <div class="row pb-4">
          <div class="col-6">
            <h3>Topics</h3>
            <ul class="list-unstyled" v-if="database.topics">
              <li v-for="topic in database.topics" :key="topic.id">
                <div v-if="topic.selected">{{topic.name_en}} / {{topic.name_sv}}</div>
                <ul v-if="topic.sub_topics.length">
                  <div v-for="subtopic in topic.sub_topics" :key="subtopic.id">
                    <li v-if="subtopic.selected">
                        <div v-if="subtopic.selected">{{subtopic.name_sv}} / {{subtopic.name_en}}</div>
                    </li>
                  </div>
                </ul>
              </li>
            </ul>
          </div>
          <div class="col-6">
            <h3>Recommended in</h3>
            <ul class="list-unstyled" v-if="database.topics">
              <li v-for="topic in database.topics" :key="topic.id">
                <div v-if="topic.recommended">{{topic.name_en}} / {{topic.name_sv}}</div>
                <ul v-if="topic.sub_topics.length">
                  <div v-for="subtopic in topic.sub_topics" :key="subtopic.id">
                    <li v-if="subtopic.recommended">
                        <div v-if="subtopic.recommended">{{subtopic.name_sv}} / {{subtopic.name_en}}</div>
                    </li>
                  </div>
                </ul>
              </li>
            </ul>
          </div>
        </div> <!-- end row -->
        <div class="row pb-4">
          <div class="col">
            <h3>Publisher</h3>
            <ul class="list-unstyled" v-if="database.publishers">
              <div v-for="publisher in database.publishers" :key="publisher.id">
                <li v-if="publisher.selected">
                  {{publisher.name}}
                </li>
              </div>
            </ul>
          </div>
        </div> <!-- end row -->
        <div class="row pb-4">
          <div class="col">
            <h3>Media type</h3>
            <ul class="list-unstyled" v-if="database.media_types">
              <div v-for="mediatype in database.media_types" :key="mediatype.id">
                <li v-if="mediatype.selected">
                  {{mediatype.name_en}} / {{mediatype.name_sv}}
                </li>
              </div>
            </ul>
          </div>
        </div> <!-- end row -->

        <div class="row pb-4">
          <div class="col">
            <h3>Database urls</h3>
            <ul class="list-unstyled" v-if="database.urls">
              <div v-for="(url, index) in database.urls" :key="index">
                <li>
                  {{url.title && url.title.length ? url.title : "No title"}} / <a target="_new" :href="url.url">{{url.url}}</a>
                </li>
              </div>
            </ul>
          </div>
        </div> <!-- end row -->

        <div class="row pb-4">
          <div class="col">
            <h3>Terms of use</h3>
            <ul class="list-unstyled" v-if="database.terms_of_use">
              <li v-for="term_of_use in database.terms_of_use">
                {{term_of_use.code}} <span class="badge bg-secondary"><strong>Permitted: </strong>{{term_of_use.permitted}}</span>
                <ul>
                  <li v-if="term_of_use.description_en.length || term_of_use.description_sv.length">
                    <div>
                      <strong>description (en):</strong>
                      {{term_of_use.description_en.length ? term_of_use.description_en : "missing english translation" }} 
                    </div>
                    <div>
                      <strong>description (sv):</strong>
                      {{term_of_use.description_sv.length ? term_of_use.description_sv : "missing swedish translation" }} 
                    </div>
                  </li> 
                </ul>
              </li>
            </ul>
          </div>
        </div>
        <div class="row pb-4">
          <div class="col">
            <h3>Access information code</h3>
              {{$t('access_information_codes.' + database.access_information_code)}}
          </div>
        </div> <!-- end row -->

            <div class="row pb-4">
          <div class="col">
            <h3>Malfunction message</h3>
              <div class="text-bg-success" v-if="database.malfunction_message_active">Enabled</div>
              <div class="text-bg-danger" v-else>Disabled</div>
              <div class="row">
                <div class="col-6">
                  <label for="malfunction_message_en" class="formkit-label">Malfunction message (en)</label>
                  <div id="malfunction_message_en" v-html="malfunction_message_en_output_en"></div>
                </div>
                <div class="col-6">
                  <label for="malfunction_message_sv" class="formkit-label">Malfunction message (sv)</label>
                  <div id="malfunction_message_sv" v-html="malfunction_message_en_output_sv"></div>
                </div>
              </div>
          </div>
        </div> <!-- end row -->
        <router-link class="btn btn-primary me-1" :to="{name: 'DatabaseEdit', params:{ id: database.id }}">Edit</router-link>
        <a href="#" @click.prevent="removeDatabase(database)" class="btn btn-danger" >Remove</a>
    </div>
  </div>

</template>

<script>
import { useRoute, useRouter } from 'vue-router'
import { useDatabasesStore } from "@/stores/databases"
import { computed, ref, onMounted } from 'vue'
import { marked } from 'marked'
import {useMessage} from '@/plugins/message'

export default {
  name: 'DatabaseShow',

  setup(props, ctx) {
    const route = useRoute();
    const router = useRouter();
    const store = useDatabasesStore();
    const database = ref({})
    const message = useMessage();
    const error = ref(null);
    const desc_en_markdown_output = computed(() => marked(database.value.description_en))
    const desc_sv_markdown_output = computed(() => marked(database.value.description_sv))
    const malfunction_message_en_output_en = computed(() => database.value.malfunction_message ? marked(database.value.malfunction_message) : "")
    const malfunction_message_en_output_sv = computed(() => database.value.malfunction_message ? marked(database.value.malfunction_message) : "")
    const removeDatabase = async (database) => {
      if (confirm("Are you sure?")) {
        const res = await store.removeDatabase(database);
        if (res.status && res.status === "deleted") {
          message.set("success", "Database has been deleted")
        }
        router.push({name:'databaseindex'});
      }
    }
    onMounted(async () => {
      error.value = null;
      const res = await store.getDatabaseById(route.params.id);
      if (res && res.error) {
        error.value = res.error;
      }
      else {
        database.value = res;
      }
      window.scrollTo(0,0);
    })
    return {
      database, 
      error,
      desc_en_markdown_output,
      desc_sv_markdown_output,
      malfunction_message_en_output_en,
      malfunction_message_en_output_sv,
      removeDatabase
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style  lang="scss">d
.db-property-header {
  font-weight: bold;
}
.formkit-label {
  font-weight: bold;
}
</style>
