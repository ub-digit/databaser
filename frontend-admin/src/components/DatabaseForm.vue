<template>
  <div v-if="database_initial_state" class="edit-topic-wrapper">
      <FormKit type="form" :actions="false">
          <div class="row">
            <div class="col">
              <h1>{{props.title}}</h1>
            </div>
            <div class="col-auto align-self-end">
                <router-link v-if="database_initial_state.id" class="btn btn-light me-2" :to="{name: 'DatabaseShow', params: {id: database_initial_state.id}}">Cancel</router-link>
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
              v-model="database_initial_state.desc_en"
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
              v-model="database_initial_state.desc_sv"
              placeholder="Description"
            />
          </div>
        </div> <!-- end row --> 
        <div class="row">
          <div class="mb-3 col-6">
            <label for="desc-preview-en" class="formkit-label">Description preview (en)</label>
            <div id="desc-preview-en"  v-html="desc_en_markdown_output">
            </div>
          </div>

          <div class="mb-3 col-6">
            <label for="desc-preview-sv" class="formkit-label">Description preview (sv)</label>
            <div id="desc-preview-sv"  v-html="desc_sv_markdown_output">
            </div>
          </div>
        </div> <!-- end row -->
        <div class="row">
          <div class="mb-3 col-6">
            <h3>Subject</h3>
            <ul class="list-unstyled" v-if="database_initial_state.topics">
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
        <div class="row">
          <div class="col">
            <h3>Media type</h3>
            <ul class="list-unstyled" v-if="database_initial_state.mediatypes && database_initial_state.mediatypes.length">
              <li v-for="mediatype in database_initial_state.mediatypes" :key="mediatype.id">
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" :id="'mediatype_' + mediatype.id" v-model="mediatype.selected">
                  <label :for="'mediatype_' + mediatype.id" class="form-check-label">{{mediatype.name_en}} / {{mediatype.name_sv}}</label>
                </div>
              </li>
            </ul>
          </div>
        </div> <!-- end row --> 
        <div class="row">
          <div class="col">
            <h3>Publisher</h3>
            <ul class="list-unstyled" v-if="database_initial_state.publishers && database_initial_state.publishers.length">
              <li v-for="publisher in database_initial_state.publishers" :key="publisher.id">
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" :id="'publisher_'+ publisher.id" v-model="publisher.selected">
                  <label :for="'publisher_'+ publisher.id" class="form-check-label">{{publisher.name}}</label>
                </div>
              </li>
            </ul>
          </div>
        </div> <!-- end row --> 
      </FormKit> <!-- end form --> 
  </div>
</template>

<script>
import { useRoute, useRouter, onBeforeRouteLeave } from 'vue-router'
import { computed, ref, watch } from 'vue'
import {useDatabasesStore} from '@/stores/databases'
import {useTopicsStore} from '@/stores/topics'
import _ from 'lodash'
import { marked } from 'marked'

export default {
  name: 'DatabaseForm',
  emits: ['saveDatabase'],
  props: ['database', 'title', 'errors'],
  setup(props, ctx) {
    const router = useRouter();
    const route = useRoute();
    const store = useDatabasesStore();
    const topicsStore = useTopicsStore();
    const values = ref([]);
    const database = props.database;
    const database_initial_state = ref(_.cloneDeep(database));
    const desc_en_markdown_output = computed(() => marked(database_initial_state.value.desc_en))
    const desc_sv_markdown_output = computed(() => marked(database_initial_state.value.desc_sv))
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
      ctx.emit('saveDatabase', database_initial_state.value);
      isSaved = true;
    }

    return {
      topicsStore,
      subTopicSelected,
      values,
      database_initial_state,
      saveDatabase,
      isDirty,
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
