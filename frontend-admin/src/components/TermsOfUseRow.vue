<template>
  <li class="pb-4">
    <div class="row">
      <div class="col mb-2">
        <strong>{{props.term_of_use.code}}</strong>
      </div>
    </div>
    <div class="row">
      <div class="col-auto">
        <div class="select mb-2">
          <select class="form-select" name="select_terms_of_use" id="'term_of_use_' + term_of_use.id" :value="props.term_of_use.permitted" 
            @change="$emit('updateTermOfUse', $event.target.value, term_of_use.code)">
            <option value="N/A">N/A</option>
            <option value="yes">permitted</option>
            <option value="no">prohibited</option>
          </select>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-6">
        <div class="desc mb-2">
          <label :for="'term_of_use_desc_en_' + term_of_use.id">description (en)</label>
          <input @keyup="$emit('updateTermOfUseDescription', $event.target.value, term_of_use.code, 'en')" type="text" class="desc_en form-control mb-2" :id="'term_of_use_desc_en_' + term_of_use.id" v-model="term_of_use.description_en">

          <label :for="'term_of_use_desc_sv_' + term_of_use.id">description (sv)</label>
          <input  @keyup="$emit('updateTermOfUseDescription', $event.target.value, term_of_use.code, 'sv')" type="text" class="desc_sv form-control" :id="'term_of_use_desc_sv_' + term_of_use.id" v-model="term_of_use.description_sv">
          
        </div>
      </div>
    </div>
  </li>
</template>

<script>

export default {
  props: ['term_of_use'],
  components: {

  },
  setup(props,ctx) {
    return {
      props
    }
  }
}
</script>