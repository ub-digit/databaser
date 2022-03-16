import { createRouter, createWebHistory } from "vue-router";
import Home from "../views/Home.vue";
import Database from "../views/Database.vue";
import Index from "../views/Index.vue";

const routes = [
  {
    path: "/",
    name: "Index",
    component: Index,
    props: route => ({ lang: route.query.lang }),
    children: [
      {
        path: "/",
        name: "Home",
        component: Home,
        props: queryHandler
      },
      {
        path: "/database/:id/:title?",
        name: "Database",
        component: Database,
      },
    ]
  },

];

function queryHandler(route) {
  return {sort_order: getSortOrder(route), topic: getTopic(route), sub_topics: getSubTopics(route), 
            mediatype: getMediatype(route), show_free: getFree(route), search: getSearch(route)};
}

const getSearch = function(route){
  if (route.query.search) {
    return route.query.search;
  }
  return undefined;
}

const getFree = function(route) {
  if (route.query.show_free === "true") {
    return true;
  }
  return false;
}
const getMediatype = function(route) {
  return route.query.mediatype ? parseInt(route.query.mediatype) : undefined;
}

const getSortOrder = function(route) {
  return route.query.sort_order;
}
const getTopic = function(route) {
  return route.query.topic ? parseInt(route.query.topic) : undefined;
}

const getSubTopics = function(route) {
  let sub_topics = [];
  if (route.query.sub_topics) {
    if (Array.isArray(route.query.sub_topics)) {
      sub_topics = [...route.query.sub_topics].map(Number);
    } else {
      sub_topics.push(parseInt(route.query.sub_topics));
    }
  }
  return sub_topics;
}

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
