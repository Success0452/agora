import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:vailwallet/dimensions.dart';
import 'package:vailwallet/user_screen.dart';

class GoingLive extends StatefulWidget {
  final int index;

  GoingLive({
    Key? key,
    required this.index
}): super(key: key);

  @override
  State<GoingLive> createState() => _GoingLiveState();
}


class _GoingLiveState extends State<GoingLive> {
  String channelName = "24e8c379-b56e-4ee5-b844-e584879f6d2a";
  String token = "0065741afe670ba4684aec914fb19eeb82aIABdbpSiC3EEGiH3lGk4fvYims28oXuwqPhIY2BW61vvdgOI38BbXy4UIgAbwog9cAeiYwQAAQCwXqFjAgCwXqFjAwCwXqFjBACwXqFj";

  int uid = 0; // uid of the local user

  bool loadState = false;

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool _isHost = true; // Indicates whether the user has joined as a host
  late RtcEngine agoraEngine; // Agora engine instance

  // late RtcEngine _engine;
  // AgoraRtmClient? _client;
  // AgoraRtmChannel? _channel;
  var users = [];
  int _decideIndex = 0;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
     initializeAgora();
  }

  @override
  void dispose() {
    users.clear();
    users.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      body: Stack(
          children: [
            loadState == true ?
            Text("waiting to create") :
            loadState == true ?
            GestureDetector(
             onTap: (){
           },
    child: Expanded(
    child: Container(
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
    border: Border.all(),
    color: Colors.white,
    ),
    child: Center(child:
    _videoPanel()
    ),
    ),
    )
    ) :
            Container(),
        const SizedBox(height: 40),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                        },
                        icon: Transform.scale(
                          scale: 1.8,
                          child: SvgPicture.asset(
                            'assets/svgs/dc-cancel.svg',
                            height: 71,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      InkWell(
                        onTap: () async {

                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: SvgPicture.asset(
                              'assets/svgs/flash-icon.svg',
                              height: 10,
                              color: Colors.white,
                              width: 10,
                              // fit: BoxFit.contain,
                            )
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      height: 80,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 3
                                )
                            ),
                            child: const CircleAvatar(
                              backgroundImage: AssetImage("assets/images/user.png"),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 140,
                            child:  Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                "9 Reachers are active now",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ]),
            ),
            Positioned(
              top: 300,
              child: Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 15,
                          offset: Offset(0.75, 0.0)
                      )
                    ]
                ),
                height: 60,
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index){
                      return Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/user.png"),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            children: const [
                              Text("Raffinha",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 8
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Go for it bro... the loading",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    }),
              ),
            ),
          const SizedBox(height: 20),
      ]),
      bottomSheet:  Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                // visible: !_isRecording,
                  child: MomentMicBtn(
                    svgUrl: 'assets/svgs/mic-solid.svg',
                    onClick: () async {
                      leave();
                    },
                  )
              ),
              SizedBox(width: 30),
              InkWell(
                onTap: () async {
                  setState(() {
                    Get.to(UserScreen());
                  });
                },
                child: Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    color: Colors.red,
                  ),
                  child: Container(
                    height: 70,
                    width: 70,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: false ? SvgPicture.asset(
                        'assets/svgs/fluent_live-24-regular.svg',
                        fit: BoxFit.contain,
                        color: Colors.black
                    ) :
                    const Icon(
                      Icons.stop,
                      color: Colors.red,
                    )
                  ),
                ),
              ),
              SizedBox(width: 30),
              Visibility(
                // visible: _isRecording,
                child: MomentCameraBtn(
                  svgUrl: 'assets/svgs/flip-camera.svg',
                  onClick: () async {
                    // agoraEngine.switchCamera();
                  },
                ),
              ),
            ]),
      ),
    );
  }

  // Widget _broadcastView(){
  //   if(!_isJoined){
  //     return const Text(
  //       'Yet to join call',
  //       textAlign: TextAlign.center,
  //     );;
  //   }else if(_isHost){
  //     return Container(
  //       child: Expanded(
  //         child: RtcLocalView.SurfaceView(channelId: channelName),
  //       ),
  //     );
  //   }else{
  //     if(_remoteUid != null){
  //       return Container(
  //         child: Expanded(
  //           child: RtcRemoteView.SurfaceView(uid: _remoteUid!, channelId: channelName),
  //         ),
  //       );
  //     }else{
  //       return const Text(
  //         'Waiting for a host to join',
  //         textAlign: TextAlign.center,
  //       );
  //     }
  //   }
  //
  // }
  //
  // Future<void> initializeAgora() async{
  //   // retrieve or request camera and microphone permissions
  //   await [Permission.microphone, Permission.camera].request();
  //
  //   _engine = await RtcEngine.createWithContext(RtcEngineContext("738da9cb2857479a9c033edf1eb7211e"));
  //   _client = await AgoraRtmClient.createInstance("738da9cb2857479a9c033edf1eb7211e");
  //
  // }
  //
  // Future<void> joinByHost() async {
  //   initializeAgora();
  //
  //   setState(() {
  //     _isHost = true;
  //   });
  //
  //   await _engine.enableAudio();
  //   await _engine.enableVideo();
  //
  //   await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
  //   await _engine.setClientRole(ClientRole.Broadcaster);
  //
  //   // callback for RTC engine
  //   _engine.setEventHandler(
  //       RtcEngineEventHandler(
  //         joinChannelSuccess: (channel, uid, elapsed){
  //           setState(() {
  //             users.add(uid);
  //             _isJoined = true;
  //           });
  //         },
  //         userJoined: (remoteUid, elapsed){
  //           setState(() {
  //             _remoteUid  = remoteUid;
  //           });
  //         },
  //         connectionStateChanged: (type, reason){
  //           print("Changes happened in " + type.name + "because of " + reason.name);
  //         },
  //         leaveChannel: (stats){
  //           setState(() {
  //             users.clear();
  //           });
  //         },
  //         userOffline: (uid, reason){
  //           print("Remote user uid:$uid left the channel");
  //           setState(() {
  //             users.remove(uid);
  //           });
  //         },
  //       )
  //   );
  //
  //   // callback for RTC engine
  //   _client?.onMessageReceived = (AgoraRtmMessage message, String peerId){
  //     print("Private Message from " + peerId + " : " + (message.text));
  //   };
  //
  //   _client?.onConnectionStateChanged = (int state, int reason){
  //     print("Connection state changed " + state.toString() + " reason" + (reason.toString()));
  //     if(state == 5){
  //       _channel?.leave();
  //       _client?.logout();
  //       _client?.destroy();
  //       print("Logged Out");
  //     }
  //   };
  //
  //   // join channel
  //   await _channel?.join();
  //   await _engine.joinChannel(token, channelName, null, uid);
  //
  //   _channel?.onMemberJoined = (AgoraRtmMember member){
  //     print("Member Joined " + member.userId + ", channel " + (member.channelId));
  //   };
  //
  //   _channel?.onMemberLeft = (AgoraRtmMember member){
  //     print("Member Left " + member.userId + ", channel " + (member.channelId));
  //   };
  //
  //   _channel?.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member){
  //     print("Public message from " + member.userId + ", channel " + (message.text));
  //   };
  // }
  //
  // Future<void> joinByAudience() async {
  //   initializeAgora();
  //
  //   setState(() {
  //     _isHost = true;
  //   });
  //
  //   await _engine.enableAudio();
  //   await _engine.enableVideo();
  //
  //   await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
  //   await _engine.setClientRole(ClientRole.Audience);
  //
  //   // callback for RTC engine
  //   _engine.setEventHandler(
  //       RtcEngineEventHandler(
  //         joinChannelSuccess: (channel, uid, elapsed){
  //           setState(() {
  //             users.add(uid);
  //             _isJoined = true;
  //           });
  //         },
  //         userJoined: (remoteUid, elapsed){
  //           setState(() {
  //             _remoteUid  = remoteUid;
  //           });
  //         },
  //         connectionStateChanged: (type, reason){
  //           print("Changes happened in " + type.name + "because of " + reason.name);
  //         },
  //         leaveChannel: (stats){
  //           setState(() {
  //             users.clear();
  //           });
  //         },
  //         userOffline: (uid, reason){
  //           print("Remote user uid:$uid left the channel");
  //           setState(() {
  //             users.remove(uid);
  //           });
  //         },
  //       )
  //   );
  //
  //   // callback for RTC engine
  //   _client?.onMessageReceived = (AgoraRtmMessage message, String peerId){
  //     print("Private Message from " + peerId + " : " + (message.text));
  //   };
  //
  //   _client?.onConnectionStateChanged = (int state, int reason){
  //     print("Connection state changed " + state.toString() + " reason" + (reason.toString()));
  //     if(state == 5){
  //       _channel?.leave();
  //       _client?.logout();
  //       _client?.destroy();
  //       print("Logged Out");
  //     }
  //   };
  //
  //   await _channel?.join();
  //   await _engine.joinChannel(token, channelName, null, uid);
  //
  //   _channel?.onMemberJoined = (AgoraRtmMember member){
  //     print("Member Joined " + member.userId + ", channel " + (member.channelId));
  //   };
  //
  //   _channel?.onMemberLeft = (AgoraRtmMember member){
  //     print("Member Left " + member.userId + ", channel " + (member.channelId));
  //   };
  //
  //   _channel?.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member){
  //     print("Public message from " + member.userId + ", channel " + (message.text));
  //   };
  // }
  //
  // void leave() {
  //   _engine.leaveChannel();
  //   _engine.destroy();
  //   _channel?.leave();
  //   _client?.logout();
  //   _client?.destroy();
  // }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    Get.back();
  }

  Widget _videoPanel() {
    if (_isHost) {
      // Local user joined as a host
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      // Local user joined as audience
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channelName),
          ),
        );
      } else {
        return const Text(
          'Waiting for a host to join',
          textAlign: TextAlign.center,
        );
      }
    }
  }

  Future<void> initializeAgora() async {
    print("testing");
    //create an instance of the Agora engine
    await [Permission.microphone, Permission.camera].request();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
        appId: "738da9cb2857479a9c033edf1eb7211e"
    ));
    print("testing2");
    await agoraEngine.enableVideo();

    //join();

    print("testing3");
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("Local user uid:${connection.localUid} joined the channel");
          //showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
            users.add(connection.localUid);
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("Remote user uid:$remoteUid joined the channel");
          // showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            users.add(remoteUid);
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print("Remote user uid:$remoteUid left the channel");
          // showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            users.clear();
            _remoteUid = null;
          });
        },
      ),
    );

    // _client?.login(token, uid.toString());
    // _channel = await _client?.createChannel(channelName);
    // await _channel?.join();

  }

  void join() async {

    // Set channel options
    ChannelMediaOptions options;
    _isHost = widget.index == 0 ? true : false;

    // Set channel profile and client role
    if (_isHost) {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    }

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );

    setState(() {
      loadState = true;
    });
  }

  Future<void> setupVideoSDKEngine() async {
    print("testing");
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
        appId: "5741afe670ba4684aec914fb19eeb82a"
    ));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("Local user uid:${connection.localUid} joined the channel");
          //showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("Remote user uid:$remoteUid joined the channel");
          // showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print("Remote user uid:$remoteUid left the channel");
          // showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

}

class MomentCameraBtn extends StatelessWidget {
  final String svgUrl;
  final double? padding;
  final Function()? onClick;
  const MomentCameraBtn({
    Key? key,
    required this.svgUrl,
    this.onClick,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 46,
        width: 46,
        padding: EdgeInsets.all(padding ?? 0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: SvgPicture.asset(
          svgUrl,
          height: 16.58,
          width: 16.58,
        ),
      ),
    );
  }
}

class MomentMicBtn extends StatelessWidget {
  final String svgUrl;
  final Function()? onClick;
  const MomentMicBtn({
    Key? key,
    required this.svgUrl,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.mic, color: Colors.white, size: 35)
      ),
    );
  }
}