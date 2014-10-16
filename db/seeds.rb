# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


institution_list = [
  [ 'UC',
  	'UC Office of the President',
  	'University of California, Office of the President',
		'.ucop.edu',
		'.*@.*ucop.edu$',
		'cdl',
		'blank_institution_logo.png',
    'urn:mace:incommon:ucop.edu',
    'ucop.edu'],



  [ 'Berkeley',
  	'UC Berkeley',
  	'University of California, Berkeley',
  	'.berkeley.edu',
  	'.*@.*berkeley.edu$',
  	'ucb',
  	'dash_ucb_logo.png',
    'urn:mace:incommon:berkeley.edu',
    'berkeley.edu'],

  [ 'UCLA',
  	'UC Los Angeles',
  	'University of California, Los Angeles',
  	'.ucla.edu',
  	'.*@.*ucla.edu$',
  	'ucla',
  	'dash_ucla_logo.png',
    'urn:mace:incommon:ucla.edu',
    'ucla.edu'],

  [ 'UCSD',
  	'UC San Diego',
  	'University of California, San Diego',
  	'.ucsd.edu',
  	'.*@.*ucsd.edu$',
  	'ucsd',
  	'blank_institution_logo.png',
    'urn:mace:incommon:ucsd.edu',
    'ucsd.edu'],

  ['UCSB',
  	'UC Santa Barbara',
  	'University of California, Santa Barbara',
  	'.ucsb.edu',
  	'.*@.*ucsb.edu$',
  	'ucsb',
  	'blank_institution_logo.png',
    'urn:mace:incommon:ucsb.edu',
    'ucsb.edu'],

  ['Davis',
  	'UC Davis',
  	'University of California, Davis',
  	'.ucdavis.edu',
  	'.*@.*ucdavis.edu$',
  	'ucd',
  	'blank_institution_logo.png',
    'urn:mace:incommon:ucdavis.edu',
    'ucdavis.edu'],

  ['Merced',
  	'UC Merced',
  	'University of California, Merced',
  	'.ucmerced.edu',
  	'.*@.*ucmerced.edu$',
  	'ucmerced',
  	'dash_ucmerced_logo.png',
    'urn:mace:incommon:ucmerced.edu',
    'ucmerced.edu'],

  ['UCSF',
  	'UC San Francisco',
  	'University of California, San Francisco',
  	'.ucsf.edu',
  	'.*@.*ucsf.edu$',
  	'ucsf',
  	'blank_institution_logo.png',
    'urn:mace:incommon:ucsf.edu',
    'ucsf.edu'],

  ['Riverside',
  	'UC Riverside',
  	'University of California, Riverside',
  	'.ucr.edu',
  	'.*@.*ucr.edu$',
  	'ucr',
  	'blank_institution_logo.png'],

  ['UCSC',
  	'UC Santa Cruz',
  	'University of California, Santa Cruz',
  	'.ucsc.edu',
  	'.*@.*ucsc.edu$',
  	'ucsc',
  	'blank_institution_logo.png',
    'urn:mace:incommon:ucsc.edu',
    'ucsc.edu'],

  ['Irvine',
  	'UC Irvine',
  	'University of California, Irvine',
  	'.uci.edu',
  	'.*@.*uci.edu$',
  	'uci',
  	'dash_uci_logo.png',
    'urn:mace:incommon:uci.edu',
    'uci.edu'],


  ['DataONE',
    'DataONE',
    'DataONE',
    '.cdlib.org',
    '.*@.*cdlib.org$',
    'cdl',
    'dash_dataone_logo.jpg']

]


institution_list.each do |abbreviation, short_name, 
													long_name, landing_page, external_id_strip, 
                          campus, logo, shib_entity_id, shib_entity_domain|
 
	Institution.create( abbreviation: abbreviation, short_name: short_name, 
											long_name: long_name, landing_page: landing_page, 
											external_id_strip: external_id_strip, 
                      campus: campus, logo: logo, shib_entity_id: shib_entity_id, shib_entity_domain: shib_entity_domain )
end



user_list = [
    ['Fake.User@ucop.edu',
     '2' ]
]


user_list.each do |external_id, institution_id|

  User.create(external_id: external_id, institution_id: institution_id)
end



