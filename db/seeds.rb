# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'ephesiansflc@gmail.com', name: "Ephesians", elder: 'Ephesians', church_group_id: 4, password: 'ephe4321', password_confirmation: 'ephe4321', is_leader: true, admin: false)
User.create(email: 'judeflc@gmail.com', name: "Jude", elder: 'Jude', church_group_id: 3, password: 'jude4321', password_confirmation: 'jude4321', is_leader: true, admin: false)
User.create(email: 'timothyflc@gmail.com', name: "Timothy", elder: 'Timothy', church_group_id: 6, password: 'timo4321', password_confirmation: 'timo4321', is_leader: true, admin: false)
User.create(email: 'lukeflcuk@gmail.com', name: "Luke", elder: 'Luke', church_group_id: 5, password: 'luke4321', password_confirmation: 'luke4321', is_leader: true, admin: false)
User.create(email: 'matthewflcuk@gmail.com', name: "Matthew", elder: 'Matthew', church_group_id: 2, password: 'matt4321', password_confirmation: 'matt4321', is_leader: true, admin: false)
User.create(email: 'jamesflcuk@gmail.com', name: "James", elder: 'James', church_group_id: 7, password: 'jame4321', password_confirmation: 'jame4321', is_leader: true, admin: false)
User.create(email: 'johnukflc@gmail.com', name: "John", elder: 'John', church_group_id: 8, password: 'john4321', password_confirmation: 'john4321', is_leader: true, admin: false)