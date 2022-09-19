import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import TopicsList from "../views/topic/List.vue";
import TopicsListIndex from "../views/topic/ListIndex.vue";
import TopicShow from "../views/topic/Show.vue";
import TopicEdit from "../views/topic/Edit.vue";
import TopicNew from "../views/topic/New.vue";
import MediatypesView from "../views/mediatype/MediatypesView.vue";
import MediatypesViewIndex from "../views/mediatype/MediatypesViewIndex.vue";
import Mediatype from "../views/mediatype/Mediatype.vue";
import MediatypeNew from "../views/mediatype/MediatypeNew.vue";
import MediatypeShow from "../views/mediatype/MediatypeShow.vue";
import MediatypeEdit from "../views/mediatype/MediatypeEdit.vue"; 
import PublishersView from "../views/publisher/PublishersView.vue";
import PublishersViewIndex from "../views/publisher/PublishersViewIndex.vue"
import Publisher from "../views/publisher/Publisher.vue"
import PublisherNew from "../views/publisher/PublisherNew.vue"
import PublisherShow from "../views/publisher/PublisherShow.vue"
import PublisherEdit from "../views/publisher/PublisherEdit.vue"

import DatabasesView from "../views/database/DatabasesView.vue";
import DatabasesViewIndex from "../views/database/DatabasesViewIndex.vue"
import Database from "../views/database/Database.vue"
import DatabaseNew from "../views/database/DatabaseNew.vue"
import DatabaseShow from "../views/database/DatabaseShow.vue"
import DatabaseEdit from "../views/database/DatabaseEdit.vue"
import NotFound from "../components/NotFound.vue"


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: HomeView,
    },
    {
      path: "/databases",
      name: "databases",
      component: DatabasesView,
      children: [
        {
          path: "",
          name: "databaseindex",
          component: DatabasesViewIndex,
          props:  {title: "database"}
        },
        {
          path: '/database',
          name: 'database',
          component: Database,
          children: [
            {
              path: "new",
              name: "DatabaseNew",
              component: DatabaseNew
            },
            {
              path: 'show/:id',
              name: 'DatabaseShow',
              component: DatabaseShow
            },
            {
              path: 'edit/:id',
              name: 'DatabaseEdit',
              component: DatabaseEdit
            }
          ]
        }
      ]
    },
    {
      path: "/publishers",
      name: "publishers",
      component: PublishersView,
      children: [
        {
          path: "",
          name: "publisherindex",
          component: PublishersViewIndex,
          props:  {title: "publisher"}
        },
        {
          path: '/publisher',
          name: 'publisher',
          component: Publisher,
          children: [
            {
              path: "new",
              name: "PublisherNew",
              component: PublisherNew
            },
            {
              path: 'show/:id',
              name: 'PublisherShow',
              component: PublisherShow
            },
            {
              path: 'edit/:id',
              name: 'PublisherEdit',
              component: PublisherEdit
            }
          ]
        }
      ]
    },
    {
      path: "/mediatypes",
      name: "mediatypes",
      component: MediatypesView,
      children: [
        {
          path: '',
          name: "mediatypeindex",
          component: MediatypesViewIndex,
          props: {title: "mediatype"}
        },
        {
          path: "/mediatype",
          name: "mediatype",
          component: Mediatype,
          children: [
            { 
              path: 'new',
              name: 'MediatypeNew',
              component: MediatypeNew
            },
            {
              path: 'show/:id',
              name: 'MediatypeShow',
              component: MediatypeShow
            },
            {
              path: 'edit/:id',
              name: 'MediatypeEdit',
              component: MediatypeEdit
            }
          ]
        }
      ]
    },
    {
      path: '/topics',
      name: 'topics',
      component: TopicsList,
      children: [
        {
          path: '',
          name: 'index',
          component: TopicsListIndex,
          props: {title: "topic"}
        },
        { 
          path: 'new',
          name: 'TopicNew',
          component: TopicNew
        },
        {
          path: 'show/:id',
          name: 'TopicShow',
          component: TopicShow
        },
        {
          path: 'edit/:id',
          name: 'TopicEdit',
          component: TopicEdit
        }
      ]
    },
    { path: '/:pathMatch(.*)*', name: 'NotFound', component: NotFound },
  ],
});

export default router;
