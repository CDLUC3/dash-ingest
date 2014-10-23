INSERT INTO `institutions` (`abbreviation`, `short_name`, `long_name`, 
                            `landing_page`, `external_id_strip`, `created_at`, 
                            `updated_at`, `campus`, `logo`, 
                            `shib_entity_id`, `shib_entity_domain`)
VALUES
                          ( 'DataONE', 'DataONE', 'DataONE',
                            '.cdlib.org', '.*@.*cdlib.org$', '2014-10-16 22:11:00',
                            '2014-10-16 22:11:00', 'dataone', 'dash_dataone_logo.jpg', 
                            NULL, NULL);


INSERT INTO `users` (`external_id`, `created_at`, 
                    `updated_at`, `email`, `institution_id`, 
                    `first_name`, `last_name`, `uid`, 
                    `provider`, `oauth_token`)

VALUES              ('Fake.User@ucop.edu', '2014-10-16 22:11:00',
                    '2014-10-16 22:11:00', 'Fake.User@ucop.edu', 1,
                    'Test', 'User', NULL,
                    NULL, NULL);
