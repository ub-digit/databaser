<template>
  <div class="ZeroState">
     <h2> <font-awesome-icon :icon="['far', 'edit']"/> Select a {{title}} to edit </h2>
  </div>
</template>

<script>
export default {
  props: ['title']
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
  h2 {
    color: #ccc;
  }
</style>
