<template>

  <div v-if="database_initial_state" class="edit-topic-wrapper">
      <div class="row">
        <div v-if="props.errors && props.errors.length" class="row mt-3">
          <div class="col">
            <div class="alert alert-danger" role="alert">
              <ul>
                <li v-for="(error,index) in props.errors" :key="index">
                  {{ error }} 
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      <FormKit type="form" :actions="false">
          <div class="row mb-4">
            <div class="col">
              <h1>{{props.title}}</h1>
            </div>
            <div class="col-auto align-self-end">
                <router-link v-if="database_initial_state.id" class="btn btn-light me-2" :to="{name: 'DatabaseShow', params: {id: database_initial_state.id}}">Cancel</router-link>
                <router-link v-else class="btn btn-light me-2" :to="{name: 'databaseindex', params: {id: database_initial_state.id}}">Cancel</router-link>
              <FormKit
                :classes="{
                  outer: 'd-inline-block',
                  input: 'btn btn-primary'
                }"
                @click.prevent="saveDatabase"
                type="submit"
                label="Save"
                :disabled="!isDirty"
              />
            </div>
        </div>

        <div v-if="props.errors" class="row mt-3">
          <div class="col">
            <div v-if="props.errors.database" class="alert alert-danger" role="alert">
              {{props.errors.database}}
          </div>
        </div>
          
        </div>
        <div class="row mb-4">
          <div class="col-auto">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="published" v-model="database_initial_state.published">
                <label class="form-check-label" for="published">Published</label>
            </div>
          </div>
          <div class="col-auto">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="isPopular" v-model="database_initial_state.is_popular">
                <label class="form-check-label" for="isPopular">Promoted as popular</label>
            </div>
          </div>
          <div class="col-auto">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="isNew" v-model="database_initial_state.is_new">
                <label class="form-check-label" for="isNew">Mark as new</label>
            </div>
          </div>
          <div class="col-auto">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="isTrial" v-model="database_initial_state.is_trial">
                <label class="form-check-label" for="isTrial">Mark as trial</label>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="mb-3 col-6">
            <FormKit 
              type="text" 
              :classes="{input: 'form-control'}"
              label="Title (en)"
              name="database_initial_state.title_en"
              v-model="database_initial_state.title_en"
              validation="required"
              placeholder="Title"
            />
          </div>
          <div class="mb-3 col-6">
            <FormKit 
              type="text" 
              :classes="{input: 'form-control'}"
              label="Title (sv)"
              name="database_initial_state.title_sv"
              v-model="database_initial_state.title_sv"
              validation="required"
              placeholder="Title"
            />
          </div>
        </div> <!-- end row -->
        <div class="row">
          <div class="mb-3 col-6">
            <FormKit 
              type="textarea" 
              :classes="{input: 'form-control'}"
              rows="10"
              label="Description (en)"
              name="database_initial_state.desc_en"
              v-model="database_initial_state.description_en"
              placeholder="Description"
            />
          </div>
          <div class="mb-3 col-6">
            <FormKit 
              type="textarea" 
              :classes="{input: 'form-control'}"
              rows="10"
              label="Description (sv)"
              name="database_initial_state.desc_sv"
              v-model="database_initial_state.description_sv"
              placeholder="Description"
            />
          </div>
        </div> <!-- end row --> 
        <div class="row">
          <div class="mb-3 col-6">
            <label for="desc-preview-en" class="formkit-label">Description preview (en)</label>
            <div id="desc-preview-en" class="faded" v-html="desc_en_markdown_output">
            </div>
          </div>

          <div class="mb-3 col-6">
            <label for="desc-preview-sv" class="formkit-label">Description preview (sv)</label>
            <div id="desc-preview-sv" class="faded"  v-html="desc_sv_markdown_output">
            </div>
          </div>
        </div> <!-- end row -->
        <div class="row">
          <div class="mb-3 col-6">
            <h3>Topics</h3>
            <ul style="max-height: 400px; overflow-y:scroll" class="list-unstyled" v-if="database_initial_state.topics">
              <li v-for="topic in database_initial_state.topics" :key="topic.id">
                <div class="form-check">
                  <input :disabled="subTopicSelected(topic)" class="form-check-input" type="checkbox" :id="topic.id" v-model="topic.selected">
                  <label class="form-check-label" :for="topic.id">{{topic.name_en}} / {{topic.name_sv}}</label>
                </div>
                <ul class="" v-if="topic.sub_topics.length">
                  <li v-for="subtopic in topic.sub_topics" :key="subtopic.id">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" :id="subtopic.id" v-model="subtopic.selected">
                      <label class="form-check-label" :for="subtopic.id">{{subtopic.name_sv}} / {{subtopic.name_en}}</label>
                    </div>
                  </li>
                </ul>
              </li>
            </ul>
          </div>
          <div class="mb-3 col-6">
            <h3>Recommended in</h3>
            <ul class="list-unstyled" v-if="database_initial_state.topics">
              <li v-for="topic in database_initial_state.topics" :key="topic.id">
                <div v-if="topic">
                  <div v-if="topic.selected" class="form-check">
                    <input :disabled="!topic.selected" class="form-check-input" type="checkbox" :id="'r_' + topic.id" v-model="topic.recommended">
                    <label class="form-check-label" :for="'r_' + topic.id">{{topic.name_en}} / {{topic.name_sv}}</label>
                  </div>
                  <ul class="" v-if="topic.sub_topics.length">
                    <div v-for="subtopic in topic.sub_topics" :key="subtopic.id">
                      <li  v-if="subtopic.selected">
                        <div class="form-check">
                          <input :disabled="!subtopic.selected" class="form-check-input" type="checkbox" :id="'r_' + subtopic.id" v-model="subtopic.recommended">
                          <label class="form-check-label" :for="'r_' + subtopic.id">{{subtopic.name_sv}} / {{subtopic.name_en}}</label>
                        </div>
                      </li>
                    </div>
                  </ul>
                </div>
              </li>
            </ul>
          </div>
        </div> <!-- end row --> 
        <div class="row mb-4">
          <div class="col">

            <h3>Publisher</h3>
            <VueMultiselect track-by="id" v-model="publishers" @select="addSelectedPublisher" @remove="removeSelectedPublisher" :multiple="true" label="name" :options="database_initial_state.publishers" ></VueMultiselect>
            <!--<ul style="max-height: 400px; overflow-y:scroll" class="list-unstyled" v-if="database_initial_state.publishers && database_initial_state.publishers.length">
              <li v-for="publisher in database_initial_state.publishers" :key="publisher.id">
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" :id="'publisher_'+ publisher.id" v-model="publisher.selected">
                  <label :for="'publisher_'+ publisher.id" class="form-check-label">{{publisher.name}}</label>
                </div>
              </li>
            </ul>-->
          </div>
        </div> <!-- end row -->
        <div class="row">
          <div class="col">
            <h3>Media type</h3>
            <ul class="list-unstyled" v-if="database_initial_state.media_types && database_initial_state.media_types.length">
              <li v-for="mediatype in database_initial_state.media_types" :key="mediatype.id">
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" :id="'mediatype_' + mediatype.id" v-model="mediatype.selected">
                  <label :for="'mediatype_' + mediatype.id" class="form-check-label">{{mediatype.name_en}} / {{mediatype.name_sv}}</label>
                </div>
              </li>
            </ul>
          </div>
        </div> <!-- end row --> 

        <div class="row mb-4">
          <div class="col-12">
          <h3>Database urls</h3>
            <ul class="list-unstyled" v-if="database_initial_state.urls">
              <li class="mb-4" v-for="(url, index) in database_initial_state.urls" :key="index">
                <div class="row">
                  <div class="col-5">
                    <FormKit 
                      type="text" 
                      :classes="{input: 'form-control'}"
                      label="URL title"
                      :name="'title_' + index"
                      v-model="url.title"
                      placeholder="Title"
                    />
                  </div>
                  <div class="col-5">
                    <FormKit 
                      type="text" 
                      :classes="{input: 'form-control'}"
                      label="URL"
                      :name="'url_' + index"
                      v-model="url.url"
                      placeholder="http://"
                    />
                  </div>
                  <div class="col-2">
                    <button @click.prevent="removeURL(index)" class="mt-4 btn btn-danger float-end">Remove</button>
                  </div>
                </div>
              </li>
            </ul>
            <button @click.prevent="addDatabaseUrl()" class="btn btn-primary">Add another url +</button>
          </div>
        </div>
         
         <div v-if="database_initial_state.terms_of_use && database_initial_state.terms_of_use.length" class="terms_of_use">
          <TermsOfUse @updateTermOfUse="updateTermOfUse" @updateTermOfUseDescription="updateTermOfUseDescription" :terms_of_use="database_initial_state.terms_of_use"/>
         </div>
      </FormKit> <!-- end form --> 

      <div class="row">
        <div class="col mb-3 ">
          <h3>Access information code</h3>
            <AccessInformationCode @updateAccessInformationCode="updateAccessInformationCode" :access_information_code="database_initial_state.access_information_code"/>
        </div>
      </div>

      <div class="row">
      <h3>Malfunction message</h3>
        <div class="row">
          <div class="col-auto mb-3">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="malfunction_message_active" v-model="database_initial_state.malfunction_message_active">
              <label class="form-check-label" for="malfunction_message_active">Enables the malfunction message (ie makes it visible to users)</label>
            </div>
          </div>
        </div>
        <div class="col-6 mb-3">
            <FormKit 
              type="textarea" 
              :classes="{input: 'form-control'}"
              rows="10"
              label="Malfunction message (en)"
              name="database_initial_state.malfunction_message"
              v-model="database_initial_state.malfunction_message"
              placeholder="Malfunction message"
            />
        </div>
        <div class="col-6 mb-3">
            <FormKit 
              type="textarea" 
              :classes="{input: 'form-control'}"
              rows="10"
              label="Malfunction message (sv)"
              name="database_initial_state.malfunction_message"
              v-model="database_initial_state.malfunction_message"
              placeholder="Malfunction message"
            />
        </div>
      </div>

      <div class="row">
        <div class="mb-3 col-6">
          <label for="malfunction_message_en" class="formkit-label">Malfunction message preview (en)</label>
          <div id="malfunction_message_en" class="faded" v-html="malfunction_message_en_output_en">
          </div>
        </div>
        <div class="mb-3 col-6">
          <label for="malfunction_message_sv" class="formkit-label">Malfunction message preview (sv)</label>
          <div id="malfunction_message_sv" class="faded"  v-html="malfunction_message_en_output_sv">
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col">
          <div class="float-end">
            <router-link v-if="database_initial_state.id" class="btn btn-light me-2" :to="{name: 'DatabaseShow', params: {id: database_initial_state.id}}">Cancel</router-link>
            <router-link v-else class="btn btn-light me-2" :to="{name: 'databaseindex', params: {id: database_initial_state.id}}">Cancel</router-link>
            <FormKit
              :classes="{
                outer: 'd-inline-block',
                input: 'btn btn-primary'
              }"
              @click.prevent="saveDatabase"
              type="submit"
              label="Save"
              :disabled="!isDirty"
            />
          </div>
        </div>
      </div>
  </div>
</template>

<script>
import { useRoute, useRouter, onBeforeRouteLeave } from 'vue-router'
import { computed, initCustomFormatter, ref, watch } from 'vue'
import {useDatabasesStore} from '@/stores/databases'
import {useTopicsStore} from '@/stores/topics'
import _ from 'lodash'
import { marked } from 'marked'
import TermsOfUse from "./TermsOfUse.vue";
import AccessInformationCode from './AccessInformationCode.vue';
import VueMultiselect from 'vue-multiselect'



export default {
  name: 'DatabaseForm',
  emits: ['saveDatabase'],
  props: ['database', 'title', 'errors'],
  components: {
    TermsOfUse,
    AccessInformationCode,
    VueMultiselect
  },
  setup(props, ctx) {
    const router = useRouter();
    const route = useRoute();
    const store = useDatabasesStore();
    const topicsStore = useTopicsStore();
    const publishers = ref([])
    const values = ref([]);
    const database = props.database;
    const database_initial_state = ref(_.cloneDeep(database));
    const desc_en_markdown_output = computed(() => database_initial_state.value.description_en ? marked(database_initial_state.value.description_en) : null)
    const desc_sv_markdown_output = computed(() => marked(database_initial_state.value.description_sv))
    const malfunction_message_en_output_en = computed(() => database_initial_state.value.malfunction_message ? marked(database_initial_state.value.malfunction_message) : "")
    const malfunction_message_en_output_sv = computed(() => database_initial_state.value.malfunction_message ? marked(database_initial_state.value.malfunction_message) : "")
    const isDirty = computed(() => _.isEqual(database, database_initial_state.value) ? false: true);
    let isSaved = false;
    watch(
      () => database_initial_state.value.topics,
      (newValue, oldValue) => {
        database_initial_state.value.topics.forEach(topic => {
          if (!topic.selected) {
            topic.recommended = false;
          }
          topic.sub_topics.forEach(subtopic => {
            if (subtopic.selected) {
              topic.selected = true;
            }
            if (!subtopic.selected) {
              subtopic.recommended = false;
            }
          })
        })
      },
      { deep: true }
    )
    const subTopicSelected = (topic) => {
      return topic.sub_topics.find(subtopic => subtopic.selected);
    }
    onBeforeRouteLeave(() => {
      if (isDirty.value && !isSaved) {
        const answer = window.confirm("It looks like you have been editing something. If you leave before saving, your changes will be lost.");
        if (!answer) return false;
      }
    })

    const saveDatabase = () => {
      const val = database_initial_state.value.urls.filter(item => item.url != "") 
      database_initial_state.value.urls = val;
      ctx.emit('saveDatabase', database_initial_state.value);
      isSaved = true;
    }

    const updateAccessInformationCode = (val) => {
      database_initial_state.value.access_information_code = val;
    }
    const addDatabaseUrl = (val) => {
      database_initial_state.value.urls.push({title: "", url: ""})
    }
    const removeURL = (index) => {
      database_initial_state.value.urls.splice(index, 1);
    }
    const updateTermOfUse = (code, val) => {
      let term_of_use = database_initial_state.value.terms_of_use.find(term_of_use => code === term_of_use.code)
      console.log(term_of_use);
      console.log(val)
      term_of_use.permitted = val;
    }

    const addSelectedPublisher = (selectedOption,id) => {
      const found = database_initial_state.value.publishers.find((publisher) => selectedOption.id === publisher.id);
      found.selected = true;
      console.log(found);
    }

    const addAllSelectedPublishersOnLoad = () => {
      const found = database_initial_state.value.publishers.filter((publisher) => {
        if (publisher.selected) {
          return publisher;
        }
      })
      publishers.value = [...found];
    }
    addAllSelectedPublishersOnLoad();

    const removeSelectedPublisher = (selectedOption, id) => {
      const found = database_initial_state.value.publishers.find((publisher) => selectedOption.id === publisher.id);
      found.selected = false;
    }
    
    const updateTermOfUseDescription = (val, code, lang) => {
      let term_of_use = database_initial_state.value.terms_of_use.find(term_of_use => code === term_of_use.code)
      if (lang === "sv") {
        term_of_use.description_sv = val;
        return;
      }
      term_of_use.description_en = val;
    }

    return {
      updateAccessInformationCode,
      updateTermOfUse,
      updateTermOfUseDescription,
      topicsStore,
      subTopicSelected,
      values,
      publishers,
      database_initial_state,
      saveDatabase,
      addDatabaseUrl,
      addSelectedPublisher,
      removeSelectedPublisher,
      removeURL,
      isDirty,
      malfunction_message_en_output_en,
      malfunction_message_en_output_sv,
      desc_en_markdown_output,
      desc_sv_markdown_output,
      props
    }
  }
}
</script>


<!-- Add "scoped" attribute to limit CSS to this component only -->
<style  lang="scss">
  .edit-topic-wrapper {
    .faded {
      opacity: 0.5;
    }
    .formkit-label {
      font-weight: bold;
    }
    #sub-topics-wrapper {
      margin-left: 20px;
      #sub-topics-list {
        li  {
          padding: 20px;
          margin-bottom: 20px;
          border: 1px dotted #ccc;
          &.is_marked_for_removal {
            opacity: .5;
          }
        }
      }
    }
  }
</style>
