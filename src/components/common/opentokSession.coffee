React = require 'react/addons'
ReactIntl = require 'react-intl'
_ = require 'underscore'
saveAs = require 'filesaver.js'

EntityStores = require '../../stores/EntityStores'
ListStores = require '../../stores/ListStores'
SessionActions = require '../../actions/SessionActions'

Utils = require '../../util/frontendUtils'

{ div, span } = React.DOM


# OpenTOK settings
apiKey = "45179622"


module.exports = React.createClass

  displayName: 'opentokSession'

  mixins: [ReactIntl]

  propTypes:
    session: React.PropTypes.object.isRequired
    sessionUser: React.PropTypes.object.isRequired

  contextTypes:
    user: React.PropTypes.object
    setBlocked: React.PropTypes.func

  getInitialState: ->
    volume: 100
    otsession: null
    subscriptions: []
    videoProportion: 1.5
    videoHeight: 400

  componentDidMount: ->
    window.addEventListener 'resize', @handleResize
    @onSessionJoin()

  componentWillUnmount: ->
    window.removeEventListener 'resize', @handleResize
    @onSessionLeave()

  componentWillReceiveProps: (next) ->
    if next.session.id isnt @props.session.id
      @onSessionLeave true

  # -- OpenTok Events --

  onSessionJoin: ->
    console.log 'onSessionJoin'
    # Join session and attach events.
    otsession = OT.initSession apiKey, @props.session.meta.opentokSession
    otsession.on 'streamCreated', (e) => @onStreamCreate e
    otsession.on 'streamDestroyed', (e) => @onStreamDestroy e
    token = @props.sessionUser.meta.opentokToken
    otsession.connect token, (e) => @onSessionConnect e
    @setState otsession: otsession

  onSessionConnect: (error) ->
    console.log 'onSessionConnect'
    # Just got connected to a session. Start streaming.
    @state.otsession.publish OT.initPublisher 'room-video',
      insertMode: 'append'
      width: 192
      height: 192
      fitMode: 'contain'

  onSessionLeave: (resetState) ->
    console.log 'onSessionLeave'
    # Disconnect and clean-up when leaving a session.
    if @state.otsession
      @state.otsession.disconnect()
    @setState @getInitialState() if resetState

  onStreamCreate: (event) ->
    console.log 'onStreamCreate'
    # A new stream has been created. Subscribe to it.
    stream = @state.otsession.subscribe event.stream, 'room-video',
      insertMode: 'append'
      width: '100%'
      height: '100%'
      fitMode: 'contain',
      (err) => @onStreamJoin stream, err
    stream.on 'videoDimensionsChanged', (e) => @onStreamResize stream, e

    streams = @state.subscriptions
    streams.push stream
    @setState subscriptions: streams
    @context.setBlocked true

  onStreamJoin: (stream, err) ->
    console.log 'onStreamJoin'
    # Just started receiving a stream.
    @setState videoProportion: stream.videoWidth() / stream.videoHeight()

  onStreamResize: (stream, event) ->
    console.log 'onStreamResize'
    # Stream changed size
    @setState videoProportion: event.newValue.width / event.newValue.height
    @handleResize()

  onStreamDestroy: (event) ->
    console.log 'onStreamDestroy', event
    # Stream finished
    streams = @state.subscriptions
    # To find the stream on the list, we have to compare by streamId.
    copy = streams.filter (s) -> s.streamId is event.stream.streamId
    pos = streams.indexOf copy[0] if copy.length
    streams.splice pos, 1 if pos isnt -1
    @setState subscriptions: streams
    @context.setBlocked false if not streams.length

  setVolume: (val) ->
    if val < 0 then val = 0
    if val > 100 then val = 100
    @setState volume: val
    for s in @state.subscriptions
      console.log 'Setting volume of:', s, 'to:', val
      s.setAudioVolume val

  takeSnapshot: (stream) ->
    img = stream.getImgData()
    blob = Utils.b64toBlob img, 'image/png'
    name = @getIntlMessage('screenshot') + ' '
    name += @formatDate(new Date(), 'datetime') + '.png'
    saveAs blob, name


  # -- React handlers --

  handleResize: ->
    width = @refs.video.getDOMNode().offsetWidth
    height = width / @state.videoProportion
    @setState videoHeight: height

  handleVolumeClick: (e) ->
    width = 50
    left = @refs.volume.getDOMNode().getBoundingClientRect().left
    val = (e.clientX - left) * 100 / width
    @setVolume val

  handleCaptureClick: ->
    if @state.subscriptions.length
      @takeSnapshot @state.subscriptions[0]

  render: ->
    div id: 'room-video', ref: 'video', style: height: @state.videoHeight,
      div className: 'video-cp',
        span className: 'icon icon-logo'
        span className: 'settings',
          span className: 'icon icon-camera', onClick: @handleCaptureClick
          span className: 'volume', ref: 'volume', onClick: @handleVolumeClick,
            span className: 'icon icon-volume off'
            span
              className: 'icon icon-volume on'
              style: width: @state.volume / 2 + 'px'
