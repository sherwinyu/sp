Sysys.HumonNodeView = Ember.View.extend
  contentBinding: null
  templateName: 'humon_node'
  classNameBindings: ['content.isLiteral:node-literal:node-collection']
  classNames: ['node']
