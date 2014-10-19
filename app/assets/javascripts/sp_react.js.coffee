console.log 'REACT JS YEAA'
window.sp = {}
rd = React.DOM

sp.ActivitiesComponent = React.createClass

  render: ->
    rd.h1 null, 'hello'

sp.ActivityComponent = React.createClass
  propTypes:
    activity: React.PropTypes.object.isRequired

  render: ->
    rd.div className: 'row',
      rd.div className: 'col-md-8',
        rd.ol null,
          rd.li null,
            "name: "
            @props.activity.name
          rd.li null,
            "category: "
            @props.activity.category
          rd.li null,
            "productivity: "
            @props.activity.productivity

$(document).ready ->
  props = window._sp_vars.props

  React.renderComponent sp.ActivityComponent(props), $('body')[0]


