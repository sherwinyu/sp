window.sp ||= {}
rd = React.DOM

sp.ResolutionsIndex = React.createClass

  propTypes:
    resolutions: React.PropTypes.array.isRequired

  render: ->
    rd.div className: 'container',
      rd.h1 null, 'Resolutions and goals'
      bs.Row null,
        rd.nav className: 'navbar navbar-default', role: 'navigation',
          rd.div className: 'collapse navbar-collapse',
            rd.form className: 'navbar-form navbar-left', role: 'search',
              bs.FormGroup null,
                bs.FormInput
                  placeholder: 'Search Activities'
                  type: 'text'
              rd.button type: 'submit', className: 'btn btn-default',
                'Go'


      bs.Row null,
        bs.Col sm: 3,
          @renderResolutions()
        bs.Col sm: 9,
          'Deets'
          # @props.activeRouteHandler
          # addNotification: @props.addNotification

  renderResolutions: ->
    rd.div className: 'resolutions',
      rd.h2 null,
        'Here are your resolutions'
      # for activity in @props.mostUsedActivities
      #   rd.div className: 'activity-summary', key: activity.id,
      #     rd.span null,
      #       Link  to: 'activity', params: {activityId: activity.id},
      #         activity.name
      #     rd.span null,
      #       utils.sToDurationString activity.duration
