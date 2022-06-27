-- Sub topics
ALTER TABLE sub_topics ADD CONSTRAINT sub_topics_fk_topics FOREIGN KEY (topic_id) REFERENCES topics (id);

ALTER TABLE database_topics ADD CONSTRAINT database_topics_fk_databases FOREIGN KEY (database_id) REFERENCES databases (id) ON DELETE CASCADE;

ALTER TABLE database_publishers ADD CONSTRAINT database_publishers_fk_databases FOREIGN KEY (database_id) REFERENCES databases (id) ON DELETE CASCADE;

ALTER TABLE database_urls ADD CONSTRAINT database_urls_fk_databases FOREIGN KEY (database_id) REFERENCES databases (id) ON DELETE CASCADE;

ALTER TABLE database_media_types ADD CONSTRAINT database_media_types_fk_databases FOREIGN KEY (database_id) REFERENCES databases (id) ON DELETE CASCADE;

ALTER TABLE database_alternative_titles ADD CONSTRAINT database_alternative_titles_fk_databases FOREIGN KEY (database_id) REFERENCES databases (id) ON DELETE CASCADE;

ALTER TABLE database_terms_of_use ADD CONSTRAINT database_terms_of_use_fk_databases FOREIGN KEY (database_id) REFERENCES databases (id) ON DELETE CASCADE;







