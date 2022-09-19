<script setup>
</script>

<template>
    <main class="home">
      <h1 class="mb-4">Database administration</h1>
      <div class="row">
        <div class="col-6">
          <div class="card mb-4">
            <div class="card-body">
              <router-link class="" :to="{name: 'index'}">Create update and delete topics</router-link> 
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-6">
          <div class="card mb-4">
            <div class="card-body">
              <router-link class="" :to="{name: 'mediatypeindex'}">Create update and delete mediatypes</router-link>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-6">
          <div class="card mb-4">
            <div class="card-body">
              <router-link class="" :to="{name: 'publisherindex'}">Create update and delete publishers</router-link>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-6">
          <div class="card mb-4">
            <div class="card-body">
              <router-link class="" :to="{name: 'databaseindex'}">Create update and delete databases</router-link>
            </div>
          </div>
        </div>
      </div>
  </main>
</template>

<style  lang="scss" scoped>
.home {
  a {
    font-size: 20px;
    text-decoration: none;
    &:hover {
      text-decoration: underline;
    }
  }
}
</style>