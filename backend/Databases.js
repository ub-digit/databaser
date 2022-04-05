const databases = {
   _meta: {
      total: 123,
      found: 12
  },
  data:  [
    {
      is_popular: true,
      id: 1,
      title: "Database 1",
      alternate_titles: ["Database one"], 
      description: "21st Century Sociology: A Reference Handbook provides a concise forum through which the vast array of knowledge accumulated, particularly during the past three decades, can be organized into a single definitive resource. The two volumes of this Reference Handbook focus on the corpus of knowledge garnered in traditional areas of sociological inquiry, as well as document the general orientation of the newer and currently emerging areas of sociological inquiry.",
      urls: [{title: 'link text', url: 'http://www.ub.gu.se'}, {title: 'link 2 text', url: 'http://www.ub.gu.se'}],
      public_access: true,
      access_information_code: "freely_available",
      publishers: [{id:1, name:'SAGE'}],
      media_types: [{id: 1, name: "mediatype_1"}, {id: 2, name: "mediatype_2"}],
      topics: [
        {id:1, name: "Economy"}, 
        {id:2, name: "Gender studies"}
      ],
      topics_recommended: [{id:11, name: "Economic history"}],
      is_recommended: true,
      malfunction_message_active: false,
      malfunction_message: 'down for maintenance',
      terms_of_use: [
        {id:1, code: "print_article_chapter", description: null, permitted: true},
        {id:2, code: "download_article_chapter", description: null, permitted: false},
        {id:3, code: "course_pack_print", description: null, permitted: true},
        {id:4, code: "gul_course_pack_electronic", description: null, permitted: true},
        {id:6, code: "scholarly_sharing", description: null, permitted: true},
        {id:7, code: "interlibrary_loan", description: "/.../links to the Licensed Work in electronic course packs and course management systems [is allowed]", permitted: true},
      ]
    },
    {
      id: 2,
      title: "Database 2",
      alternate_titles: ["Database two"], 
      description: "21st Century Sociology: A Reference Handbook provides a concise forum through which the vast array of knowledge accumulated, particularly during the past three decades, can be organized into a single definitive resource. The two volumes of this Reference Handbook focus on the corpus of knowledge garnered in traditional areas of sociological inquiry, as well as document the general orientation of the newer and currently emerging areas of sociological inquiry.",
      urls: [{title: 'link text', url: 'http://www.ub.gu.se'}],
      public_access: false,
      access_information_code: "available_to_the_university_of_gothenburg",
      publishers: [{id:1, name:'SAGE'}],
      media_types: [{id: 1, name: "mediatype_1"}, {id: 2, name: "mediatype_2"}],
      topics: [
        {id:1, name: "Economy", sub_topics: [{id:12, name: "Economic future"}, {id:11, name: "Economic history"}] }, 
        {id:2, name: "Gender studies"}
      ],
      topics_recommended: [
        {id:11, name: "Economic history", parentID: 1}, 
        {id:2, name: "Gender studies", parentID: null},
        {id:3, name: "Technology", sub_topics: [{id:22, name: "Computer science"}]}
      ],
      is_recommended: true,
      malfunction_message_active: false,
      malfunction_message: 'down for maintenance',
      terms_of_use: [
        {id:1, code: "print_article_chapter", description: null, permitted: true},
        {id:2, code: "download_article_chapter", description: null, permitted: false},
        {id:3, code: "course_pack_print", description: null, permitted: true},
        {id:4, code: "gul_course_pack_electronic", description: null, permitted: true},
        {id:6, code: "scholarly_sharing", description: null, permitted: true},
        {id:7, code: "interlibrary_loan", description: "/.../links to the Licensed Work in electronic course packs and course management systems [is allowed]", permitted: true},
      ]
    }
  ],
  filters: {
    mediatypes: [
      {
        id: 1,
        name: "mediatype_1",
      },
      {
        id: 2,
        name: "mediatype_2",
      },
      {
        id: 3,
        name: "mediatype_3",
      },
    ],
    topics : [
      {
        id: 1,
        name: "Economy",
        sub_topics: [
          {
            id: 11,
            name: "Economic history",
          },
          {
            id: 12,
            name: "Economic future",
          },
        ],
      },
      {
        id: 2,
        name: "Gender studies",
      },
      {
        id: 3,
        name: "Technology",
        sub_topics: [
          {
            id: 22,
            name: "Computer science",
          },
          {
            id: 23,
            name: "Engineering",
          },
        ],
      },
    ]
  }

}
module.exports = databases;
