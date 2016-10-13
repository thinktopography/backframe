require 'active_record'


greg_photo = Backframe::Fixtures::Photo.create(path: '/images/greg.jpg')
megan_photo = Backframe::Fixtures::Photo.create(path: '/images/megan.jpg')
kath_photo = Backframe::Fixtures::Photo.create(path: '/images/kath.jpg')
armand_photo = Backframe::Fixtures::Photo.create(path: '/images/armand.jpg')

greg = Backframe::Fixtures::Contact.create(first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: greg_photo)
megan = Backframe::Fixtures::Contact.create(first_name: 'Megan', last_name: 'Pugh', email: 'megan@thinktopography.com', photo: megan_photo)
kath = Backframe::Fixtures::Contact.create(first_name: 'Kath', last_name: 'Tibbetts', email: 'kath@thinktopography.com', photo: kath_photo)
armand = Backframe::Fixtures::Contact.create(first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: armand_photo)
