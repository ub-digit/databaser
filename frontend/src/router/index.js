import { createRouter, createWebHistory } from "vue-router";
import Home from "../views/Home.vue";
import Database from "../views/Database.vue";

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/database/:id",
    name: "Database",
    component: Database,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
