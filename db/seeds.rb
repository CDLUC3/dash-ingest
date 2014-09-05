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
		'blank_institution_logo.png' ],

  [ 'Berkeley',
  	'UC Berkeley',
  	'University of California, Berkeley',
  	'.berkeley.edu',
  	'.*@.*berkeley.edu$',
  	'ucb',
  	'dash_ucb_logo.png'],

  [ 'UCLA',
  	'UC Los Angeles',
  	'University of California, Los Angeles',
  	'.ucla.edu',
  	'.*@.*ucla.edu$',
  	'ucla',
  	'dash_ucla_logo.png'],

  [ 'UCSD',
  	'UC San Diego',
  	'University of California, San Diego',
  	'.cdlib.org',
  	'.*@.*ucsd.edu$',
  	'ucsd',
  	'blank_institution_logo.png'],

  ['UCSB',
  	'UC Santa Barbara',
  	'University of California, Santa Barbara',
  	'.ucop.edu',
  	'.*@.*ucsb.edu$',
  	'ucsb',
  	'blank_institution_logo.png'],

  ['Davis',
  	'UC Davis',
  	'University of California, Davis',
  	'.cdlib.org',
  	'.*@.*ucdavis.edu$',
  	'ucd',
  	'blank_institution_logo.png'],

  ['Merced',
  	'UC Merced',
  	'University of California, Merced',
  	'.cdlib.org',
  	'.*@.*ucmerced.edu$',
  	'ucm',
  	'blank_institution_logo.png'],

  ['UCSF',
  	'UC San Francisco',
  	'University of California, San Francisco',
  	'.cdlib.org',
  	'.*@.*ucsf.edu$',
  	'ucsf',
  	'blank_institution_logo.png'],

  ['Riverside',
  	'UC Riverside',
  	'University of California, Riverside',
  	'.cdlib.org',
  	'.*@.*ucr.edu$',
  	'ucr',
  	'blank_institution_logo.png'],

  ['UCSC',
  	'UC Santa Cruz',
  	'University of California, Santa Cruz',
  	'.cdlib.org',
  	'.*@.*ucsc.edu$',
  	'ucsc',
  	'blank_institution_logo.png'],

  ['Irvine',
  	'UC Irvine',
  	'University of California, Irvine',
  	'.cdlib.org',
  	'.*@.*uci.edu$',
  	'uci',
  	'blank_institution_logo.png']
]

institution_list.each do |abbreviation, short_name, 
													long_name, landing_page, external_id_strip, 
                          campus, logo|
 
	Institution.create( abbreviation: abbreviation, short_name: short_name, 
											long_name: long_name, landing_page: landing_page, 
											external_id_strip: external_id_strip, 
                      campus: campus, logo: logo )
end







