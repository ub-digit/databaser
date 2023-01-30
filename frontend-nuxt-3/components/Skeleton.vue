<template>
    <div>
        <div class="topics">
            <h2>Topics</h2>
            <ul>
                <li v-for="i in [...Array(10).keys()]" :key="i">
                </li>
            </ul>
        </div>
    </div>
</template>

<style scoped>
ul > li {
    height: 20px;
    width: 100%;
    background: #aeaeae no-repeat;
    margin-bottom: 10px;
    animation: pulse 2s ease-in-out infinite;
    animation-delay: 0.1s;
}

@keyframes pulse {
  0% {
    opacity: 1;
  }
  50% {
    opacity: 0.4;
  }
  100% {
    opacity: 1;
  }
}

</style>