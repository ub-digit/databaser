<template>
<div class="navigation_wrapper">
  <div class="navbar navbar-dark bg-primary navbar-expand-sm">
    <div class="container-fluid">
      <a class="navbar-brand" href="/">
        <span class="logo"><img :src="'/img/gub-textlogo-en.svg'" alt="logo"></span> | Database admin
      </a>
      <div class="navbar-collapse" id="navbarNav">
        <ul class="navbar-nav">
          <li class="nav-item">
            <router-link :to="{name: 'home'}" class="nav-link">Home</router-link>
          </li>
          <li class="nav-item" >
            <router-link :to="{name: 'index'}" class="nav-link">Topics</router-link>
          </li>
          <li class="nav-item" >
            <router-link :to="{name: 'mediatypeindex'}" class="nav-link">Mediatypes</router-link>
          </li>
          <li class="nav-item" >
            <router-link :to="{name: 'publisherindex'}" class="nav-link">Publishers</router-link>
          </li>
          <li class="nav-item" >
            <router-link :to="{name: 'databaseindex'}" class="nav-link">Databases</router-link>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>
</template>

<script>

export default {
  components: {
  },
  setup() {

  }
}
</script>

<style lang="scss" >
.navigation_wrapper {
  .navbar {
    margin-bottom: 20px;
    .nav-item {
      a {
        &:hover, &:focus {
            background-color: transparent;
          
        }
        &.router-link-active {
          background: transparent;
          border-bottom: 2px solid white;
        }
      }
    }
  }

}
</style>