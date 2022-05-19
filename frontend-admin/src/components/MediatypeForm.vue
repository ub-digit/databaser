<template>
  <div class="edit-topic-wrapper">
    <div v-if="mediatype_initial_state">
      <FormKit type="form" :actions="false">
          <div class="row">
            <div class="col">
              <h1>{{props.title}}</h1>
            </div>
            <div class="col-auto align-self-end">
                <router-link v-if="mediatype_initial_state.id" class="btn btn-light me-2" :to="{name: 'MediatypeShow', params: {id: mediatype_initial_state.id}}">Cancel</router-link>
              <FormKit
                :classes="{
                  outer: 'd-inline-block',
                  input: 'btn btn-primary'
                }"
                @click.prevent="saveMediatype"
                type="submit"
                label="Save"
                :disabled="!isDirty"
              />
            </div>
        </div>

        <div v-if="props.errors" class="row mt-3">
          <div class="col">
            <div v-if="props.errors.mediatype" class="alert alert-danger" role="alert">
              {{props.errors.mediatype}}
          </div>
        </div>
          
        </div>
        <div class="row">
          <div class="mb-3 col-6">
            <FormKit 
              type="text" 
              :classes="{
                input: 'form-control'
              }"
              label="Mediatype (en)"
              name="mediatype_initial_state.title_en"
              v-model="mediatype_initial_state.title_en"
              validation="required"
              placeholder="Enter mediatype in english"
            />
          </div>
          <div class="mb-3 col-6">
            <FormKit 
              type="text" 
              :classes="{
                input: 'form-control'
              }"
              label="Mediatype (sv)"
              name="mediatype_initial_state.title_sv"
              v-model="mediatype_initial_state.title_sv"
              placeholder="Enter mediatype in swedish"
            />
          </div>
        </div>
      </FormKit>
    </div>
  </div>
</template>

<script>
import { useRoute, useRouter, onBeforeRouteLeave } from 'vue-router'
import { computed, ref } from 'vue'
import {useMediatypesStore} from '@/stores/mediatypes'
import _ from 'lodash'

export default {
  name: 'MediatypeForm',
  emits: ['saveMediatype'],
  props: ['mediatype', 'title', 'errors'],
  setup(props, ctx) {
    const router = useRouter();
    const route = useRoute();
    const store = useMediatypesStore();
    const mediatype = props.mediatype;
    const mediatype_initial_state = ref(_.cloneDeep(mediatype));
    const isDirty = computed(() => _.isEqual(mediatype, mediatype_initial_state.value) ? false: true);
    let isSaved = false;
  

    onBeforeRouteLeave(() => {
      if (isDirty.value && !isSaved) {
        const answer = window.confirm("It looks like you have been editing something. If you leave before saving, your changes will be lost.");
        if (!answer) return false;
      }
    })
    const saveMediatype = () => {
      ctx.emit('saveMediatype', mediatype_initial_state.value);
      isSaved = true;
    }
    return {
      mediatype_initial_state,
      saveMediatype,
      isDirty,
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
