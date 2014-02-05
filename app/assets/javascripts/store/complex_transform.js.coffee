Sysys.ComplexTransform = DS.Transform.extend
  deserialize: (json) ->
    json
    # Convert it to a node, then back to a val.... why are we doing this?
    # Actually, I don't see a reason to do this. Commentnig out for now.
    # HumonUtils.json2node(json, suppressNodeParentWarning: yes, suppressControllerWarning: yes).val()

  serialize: (json) ->
    json
