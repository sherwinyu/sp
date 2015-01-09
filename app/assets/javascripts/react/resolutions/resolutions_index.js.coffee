window.sp ||= {}
rd = React.DOM

sp.ResolutionsIndex = React.createClass

  propTypes:
    resolutions: React.PropTypes.array.isRequired

  render: ->
    rd.div className: 'container',
      rd.h1 null, 'Goal management'
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
        bs.Col sm: 8,
          @renderResolutions()

        # bs.Col sm: 3,
        #   @renderResolutions()
        # bs.Col sm: 9,
        #   'Deets'
          # @props.activeRouteHandler
          # addNotification: @props.addNotification

  renderResolutionItem: (resolutionText, options) ->
    {
      trackFrequency, routine, helpText, count, goal, doneInInterval
    } = options

    if helpText
      return rd.p null,
        rd.span className: 'label label-warning', '!'
          resolutionText

    rd.li null,
      bs.Row null,
        bs.Col sm: 8,
          rd.p null,
            resolutionText

            if trackFrequency
              rd.span className: 'label label-info', trackFrequency

            if routine
              rd.ol null,
                for step in routine
                  rd.li null, step

        bs.Col sm: 3,
          if count? and goal?
            rd.div className: 'progress',
              rd.div
                className: 'progress-bar'
                'aria-valuemin': 0
                'aria-valuenow': count
                'aria-valuemax': goal
                style:
                  width: "#{count / goal * 100}%"
              ,
                "#{count}/#{goal}"

        bs.Col sm: 1,
          rd.button
            className: 'btn btn-primary btn-sm'
            type: 'button'
          ,
            'Track now '
            rd.span
              className: 'badge'
            ,
              if doneInInterval then 'DONE' else 'NOT DONE YET'

  renderResolutionTitle: (title) ->
    rd.h4 null, title

  renderResolutions: ->
    rd.div className: 'resolutions',
      rd.h3 null,
        'Reslutions'

      rd.div className: 'resolution-theme',
        @renderResolutionTitle 'I. Be more appreciative'
        rd.ol null,
          @renderResolutionItem 'Commit by Friday 5pm',
            trackFrequency: 'weekly'
            count: 23
            goal: 150
            doneInInterval: true
          @renderResolutionItem 'Once either sunday or saturday', trackFrequency: 'weekly'
          @renderResolutionItem 'Scehdule',
            routine: ['30m mindfulness meditation', '30m express appreciation', '120m play/work session']
          @renderResolutionItem 'Treat this as higher priority over other things',
            helpText: true


      rd.div className: 'resolution',
        @renderResolutionTitle 'II. Utilize Sherwin Points'

      rd.div className: 'resolultion-theme',
        @renderResolutionTitle 'III. Utilize Sherwin Points'

      rd.div className: '',
        @renderResolutionTitle 'IV. Personal projects'

      rd.div className: '',
        @renderResolutionTitle 'IV. Persoal projects'


      # for activity in @props.mostUsedActivities
      #   rd.div className: 'activity-summary', key: activity.id,
      #     rd.span null,
      #       Link  to: 'activity', params: {activityId: activity.id},
      #         activity.name
      #     rd.span null,
      #       utils.sToDurationString activity.duration
