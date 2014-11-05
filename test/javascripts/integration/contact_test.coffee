store = contact = user1 = null
# Set the store to a fixture adapter for now
# TODO: consider using a Pretender server & use sync adapter
#       for more realistic coverage
App.Contact.FIXTURES = []
App.Connection.FIXTURES = []
App.Relationship.FIXTURES = []
App.User.FIXTURES = []
App.Store = DS.Store.extend({adapter: DS.FixtureAdapter})

module "Contact Index Page integration tests", 
  setup: ->
    $.cookie('remember_token', 'get logged in')
    Ember.run ->
      store = App.__container__.lookup("store:main")
  teardown: ->
    App.reset()
test "fills in a new contact", ->
  visit("/contacts/")
  fillIn("#contact-search", "Anna Bobana")
  click(".new-contact > a")
  andThen ->
    equal(currentPath(), "contacts.new", "should be" + currentPath())
    equal("Anna Bobana", find("#contact-search").val(), "names should be same " + find("#contact-search").val())
    equal("Anna Bobana", find("#name").val(), "names should be same " + find("#name").val())
    equal("Add Anna Bobana", find(".new-contact > a").text().trim(), "should be Add + name")


test "edits the user assigned", ->
  Ember.run ->
    store.createRecord("user",
      name: "Peiying Wen")
  targetContact = null
  Ember.run ->
    targetContact = store.createRecord("user",
      name: "Inger Dickson")
  contact = null
  Ember.run ->
    contact = store.createRecord('contact',
      name: "Ms McGrethory", createdAt: new Date(2012, 8, 6))
  visit("/contacts/" + contact.get('id') + "/edit")
  andThen ->
    users = find("#contact-user")
    ok(/Peiying Wen/.test(users.text()))
    ok(/Inger Dickson/.test(users.text()))
  fillIn("#contact-user select", targetContact.get("id"))
  andThen ->
    users = find("#contact-user")
    ok(/Peiying Wen/.test(users.text()))
    ok(/Inger Dickson/.test(users.text()))
  click("#update-contact")
  andThen ->
    ok(/Inger Dickson/.test(find("#user").text()))
    App.Contact.FIXTURES = []

test "creates a new contact", ->
  visit("/contacts/")
  fillIn("#contact-search", "Anna Bobana")
  click(".new-contact > a")
  click("#save-contact")
  andThen ->
    equal(currentPath(), "contacts.contact.index", "should be" + currentPath())
    equal("Anna Bobana", find("h3#contact-name").text(), "name should display in header")
    click(".delete-contact")
    click(".confirm")

test "creates a new contact with full information", ->
  visit("/contacts/")
  fillIn("#contact-search", "Ion Worris")
  click(".new-contact > a")
  fillIn("#city", "Lake Forest")
  fillIn("#bio", "just wants to be king of the pirates")
  click("#save-contact")
  andThen ->
    equal("Ion Worris", find("h3#contact-name").text(), "name should display in header")
    ok(find(".top-info").text().indexOf("Lake Forest") > -1, "should find the city in the top info")
    ok(find(".bio").text().indexOf("just wants to be king of the pirates") > -1, "should find the bio")
    click(".delete-contact")
    click(".confirm")

test "shows all people in sidebar with same name", ->
  andThen ->
    visit("/contacts/")
  andThen ->
    equal(store.find('contact').get('length'), 0, "the store should have zero " + store.find('contact').get('length'))
    equal(find(".contact").length, 0, "Should show zero people in list by default: " + find("li.contact").length)
    Ember.run ->
      contact = store.createRecord('contact',
        name: "Catherine MacKinnon", createdAt: new Date(2012, 8, 6))
      contact2 = store.createRecord('contact',
        name: "Catherine MacDonald", createdAt: new Date(2012, 8, 6))
      otherContact = store.createRecord('contact',
        name: "Andrea Dworkin", createdAt: new Date(2012,8,7))
  visit("/contacts/")
  andThen ->
    equal(find(".contact").length, 3, "Should show three people in list by default: " + find("li.contact").length)

test "shows only people with matching string in name", ->
  Ember.run ->
    contact = store.createRecord('contact',
      name: "Cat Dog", createdAt: new Date(2012, 8, 6))
    contact2 = store.createRecord('contact',
      name: "Catherine The Great", createdAt: new Date(2012, 8, 6))
    otherContact = store.createRecord('contact', 
      name: "Andrea Dworkin", createdAt: new Date(2012,8,7))
  visit("/contacts/")
  fillIn("#contact-search", "Cat")
  andThen ->
    equal(find(".contact").length, 2, "Should show matching on name")