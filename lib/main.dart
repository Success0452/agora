import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:vailwallet/going_life.dart';
import 'package:get/get.dart';
import 'package:vailwallet/user_posting.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  String channelName = "7c759f78-63f7-4984-8b9e-475e67f2916c";
  String token = "0065741afe670ba4684aec914fb19eeb82aIAAQOQ3jBJ+6xoBnwOj9JbeZYCyHUJ6HJ+qntRHhOGi2IizPRtRbXy4UIgDUglJVfhCkYwQAAQC+Z6NjAgC+Z6NjAwC+Z6NjBAC+Z6Nj";

  int uid = 0; // uid of the local user
  var loadState = ValueNotifier(false);

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool muted = false;
  bool videoDisabled = false;
  bool _isHost = true; // Indicates whether the user has joined as a host or audience
  late RtcEngine agoraEngine; // Agora engine instance

  // late RtcEngine _engine;
  // AgoraRtmClient? _client;
  // AgoraRtmChannel? _channel;

  List<int> users = [];

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey
  = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  ThemeData _baseTheme = ThemeData(
    canvasColor: Colors.transparent,
  );

  @override
  void initState() {
    super.initState();
     //initializeAgora();
    // Set up an instance of Agora engine
     setupVideoSDKEngine();
    _addEventHandler();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: _baseTheme,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Testing Live Streaming'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            children: [
              // Container for the local video
              Container(
                height: 240,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child:
                 _videoPanel()
                ),
              ),
              // Radio Buttons
              Row(children: <Widget>[
                Radio<bool>(
                  value: true,
                  groupValue: _isHost,
                  onChanged: (value) => _handleRadioValueChange(value),
                ),
                const Text('Host'),
                Radio<bool>(
                  value: false,
                  groupValue: _isHost,
                  onChanged: (value) => _handleRadioValueChange(value),
                ),
                const Text('Audience'),
              ]),
              // Button Row
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Join"),
                          onPressed: () => {
                            // setupVideoSDKEngine(),
                             join()
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Leave"),
                          onPressed: () => {
                             leave()
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Next"),
                          onPressed: () => {
                            Get.to(GoingLive(index: 0,))
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Next2"),
                          onPressed: () => {
                           // Get.to(GoingLive(index: 1,))
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Terminate"),
                          onPressed: () => {

                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Switch"),
                          onPressed: () => {
                           // agoraEngine.switchCamera()
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Mute"),
                          onPressed: () => {
                          setState(() {
                          muted = !muted;
                          }),
                          // agoraEngine.muteLocalAudioStream(muted)
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Disable"),
                          onPressed: () => {
                            setState(() {
                              videoDisabled = !videoDisabled;
                            }),
                            // agoraEngine.muteLocalVideoStream(true)
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Mute"),
                          onPressed: () => {
                            setState(() {
                              muted = !muted;
                            }),
                           // agoraEngine.muteLocalAudioStream(muted)
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("Disable"),
                          onPressed: () => {
                            setState(() {
                              videoDisabled = !videoDisabled;
                            }),
                            // agoraEngine.muteLocalVideoStream(true)
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Button Row ends
            ],
          )),
    );
  }

  Widget _videoPanel() {
    if(_isJoined == false){
      return const Text(
        'Yet to join call',
        textAlign: TextAlign.center,
      );
    }
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

// Set the client role when a radio button is selected
  void _handleRadioValueChange(bool? value) async {
    setState(() {
      _isHost = (value == true);
    });
    // if (_isJoined) leave();
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

  // Future<void> initializeAgora() async{
  //   // retrieve or request camera and microphone permissions
  //   await [Permission.microphone, Permission.camera].request();
  //
  //   _engine = await RtcEngine.createWithContext(RtcEngineContext("eccf72d576504a7cbe83aeef09d0c16d"));
  //   _client = await AgoraRtmClient.createInstance("eccf72d576504a7cbe83aeef09d0c16d");
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
  //           joinChannelSuccess: (channel, uid, elapsed){
  //             setState(() {
  //               users.add(uid);
  //               _isJoined = true;
  //             });
  //           },
  //           userJoined: (remoteUid, elapsed){
  //             setState(() {
  //               _remoteUid  = remoteUid;
  //             });
  //           },
  //           connectionStateChanged: (type, reason){
  //             print("Changes happened in " + type.name + "because of " + reason.name);
  //           },
  //           leaveChannel: (stats){
  //             setState(() {
  //               users.clear();
  //             });
  //           },
  //           userOffline: (uid, reason){
  //             print("Remote user uid:$uid left the channel");
  //              setState(() {
  //                users.remove(uid);
  //              });
  //           },
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
  //           joinChannelSuccess: (channel, uid, elapsed){
  //             setState(() {
  //               users.add(uid);
  //               _isJoined = true;
  //             });
  //           },
  //           userJoined: (remoteUid, elapsed){
  //             setState(() {
  //               _remoteUid  = remoteUid;
  //             });
  //           },
  //           connectionStateChanged: (type, reason){
  //             print("Changes happened in " + type.name + "because of " + reason.name);
  //           },
  //           leaveChannel: (stats){
  //             setState(() {
  //               users.clear();
  //             });
  //           },
  //           userOffline: (uid, reason){
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
  //   _client?.destroy();
  // }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();
    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
        appId: "eccf72d576504a7cbe83aeef09d0c16d",
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting
    ));

    await agoraEngine.enableVideo();
    await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await agoraEngine.startPreview();
    agoraEngine.enableWebSdkInteroperability(true);

    _addEventHandler();
  }

  void _addEventHandler() async {

    // Register the event handler
    agoraEngine.registerEventHandler(

      RtcEngineEventHandler(
        onUserStateChanged: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;

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


    _addEventHandler();

  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    super.dispose();
  }


}