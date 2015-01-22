window.sp ||= {}
rd = React.DOM

sp.ResolutionsIndex = React.createClass

  propTypes:
    # Resolution refers to a single trackable item, and they are grouped together
    # ResolutionCompletion
    #
    # resolution: React.PropType.shape(
    #   groupName: 'Utilize Sherwin Points'
    #   name: React.PropTypes.string
    #   frequency: React.PropTypes.string
    #   recentCompletions: array
    #   isHeader
    #   information
    #   type: {info, header, goal}






    # ).isRequired
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

  renderResolutionTitle: (title) ->
    rd.h4 null, title

  renderResolutionItem: (text, options) ->
    sp.ResolutionItem
      text: text
      options: options

  renderResolutions: ->
    rd.div className: 'resolutions',
      rd.h3 null,
        'Reslutions'

      rd.div className: 'panel panel-default resolution-theme',
        rd.div className: 'panel-heading',
          @renderResolutionTitle 'I. Be more appreciative'
        rd.ul className: 'list-group',
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

sp.ResolutionItem = React.createClass

  propTypes:
    text: React.PropTypes.string.isRequired
    options: React.PropTypes.shape(
      trackFrequency: React.PropTypes.string
      routine: React.PropTypes.object
      helpText: React.PropTypes.boolean
      count: React.PropTypes.number
      goal: React.PropTypes.number
      doneInInterval: React.PropTypes.boolean
    )

  getInitialState: ->
    expanded: false

  toggleExpanded: ->
    @setState expanded: not @state.expanded

  render: ->
    text = @props.text
    {
      trackFrequency, routine, helpText, count, goal, doneInInterval
    } = @props.options

    rd.li
      className: 'list-group-item',
      onClick: @toggleExpanded
    ,
      if not @state.expanded
        rd.p null,
          text

      if @state.expanded
        bs.Row null,
          bs.Col sm: 7,
            rd.p null,
              text

              if trackFrequency
                rd.span className: 'label label-info u-tiny-spacing-left', trackFrequency

              if routine
                rd.ol null,
                  for step in routine
                    rd.li null, step

          bs.Col sm: 5,
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

            if not helpText
              rd.button
                className: 'btn btn-primary btn-sm'
                type: 'button'
              ,
                'Track now '
              if not doneInInterval
                rd.span
                  className: 'badge u-tiny-spacing-left'
                ,
                  '!'
