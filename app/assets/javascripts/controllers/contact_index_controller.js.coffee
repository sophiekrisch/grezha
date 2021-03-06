App.ContactIndexController = Ember.ObjectController.extend App.HasConfirmation,
  needs: "contacts"
  allPeople: []
  filterByMode: null

  connectionsToShow: (->
    return @get("sortedConnections") unless @get("filterByMode")?

    @get("sortedConnections").filter (connection)=>
      connection.get("mode") == @get("filterByMode")
  ).property('connections.@each', 'filterByMode')

  reset: ->
    @set('addingRelationship', false)
    @set('addingConnection', false)
    @set('filterByMode', null)

  actions:
    deleteClient: ->
      @set 'confirmation',
        heading: "Are you sure?"
        content: "Are you sure you want to delete this client? It will be gone forever!"
        show: true
        button: "Delete"
        action: =>
          @get('model').deleteRecord()
          @get('model').save()
          @transitionToRoute('contacts')

    newConnection: -> @set("addingConnection", true)
    cancelNewConnection: -> @set("addingConnection", false)
    newRelationship: -> @set('addingRelationship', true)
    cancelNewRelationship: -> @set('addingRelationship', false)
    filterMode: (mode)-> @set('filterByMode', mode)
    changeImage: (url)-> @set('model.pictureUrl', url)

