import { createRouter, createWebHistory } from "vue-router";
import Home from "../views/Home.vue";
import Database from "../views/Database.vue";



const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
    props: queryHandler
  },
  {
    path: "/database/:id",
    name: "Database",
    component: Database,
  },
];


function queryHandler(route) {
  return {sortOrder: getSortOrder(route), topicFirstLevel: getTopicFirstLevel(route), topicsSecondLevel: getTopicsSecondLevel(route), 
            mediatype: getMediatype(route), showFree: getFree(route), lang: getLang(route),
            search: getSearch(route)};
}

const getSearch = function(route){
  if (route.query.search) {
    return route.query.search;
  }
  return undefined;
}

const getLang = function(route) {
  if (route.query.lang) {
    return route.query.lang;
  }
  return undefined;
}

const getFree = function(route) {
  if (route.query.showFree === "true") {
    return true;
  }
  return false;
}
const getMediatype = function(route) {
  return route.query.mediatype ? parseInt(route.query.mediatype) : undefined;
}

const getSortOrder = function(route) {
  return route.query.sortOrder;
}
const getTopicFirstLevel = function(route) {
  return route.query.topicFirstLevel ? parseInt(route.query.topicFirstLevel) : undefined;
}

const getTopicsSecondLevel = function(route) {
  let topicsSecondeLevelArr = [];
  const topicsSecondLevel = route.query.topicsSecondLevel;

  if (route.query.topicsSecondLevel) {
    if (Array.isArray(route.query.topicsSecondLevel)) {
      topicsSecondeLevelArr = [...route.query.topicsSecondLevel].map(Number);
    } else {
      topicsSecondeLevelArr.push(parseInt(topicsSecondLevel));
    }
  }
  return topicsSecondeLevelArr;
}

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
