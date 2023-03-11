// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      perfs: json['perfs'] == null
          ? null
          : Perfs.fromJson(json['perfs'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as int?,
      disabled: json['disabled'] as bool?,
      tosViolation: json['tosViolation'] as bool?,
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      seenAt: json['seenAt'] as int?,
      patron: json['patron'] as bool?,
      verified: json['verified'] as bool?,
      playTime: json['playTime'] == null
          ? null
          : PlayTime.fromJson(json['playTime'] as Map<String, dynamic>),
      title: $enumDecodeNullable(_$TitleEnumMap, json['title']),
      url: json['url'] as String?,
      playing: json['playing'] as String?,
      count: json['count'] == null
          ? null
          : Count.fromJson(json['count'] as Map<String, dynamic>),
      streaming: json['streaming'] as bool?,
      followable: json['followable'] as bool?,
      following: json['following'] as bool?,
      blocking: json['blocking'] as bool?,
      followsYou: json['followsYou'] as bool?,
      stream: json['stream'] == null
          ? null
          : LiveStream.fromJson(json['stream'] as Map<String, dynamic>),
      streamer: json['streamer'] == null
          ? null
          : LiveStreamer.fromJson(json['streamer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'perfs': instance.perfs,
      'createdAt': instance.createdAt,
      'disabled': instance.disabled,
      'tosViolation': instance.tosViolation,
      'profile': instance.profile,
      'seenAt': instance.seenAt,
      'patron': instance.patron,
      'verified': instance.verified,
      'playTime': instance.playTime,
      'title': _$TitleEnumMap[instance.title],
      'url': instance.url,
      'playing': instance.playing,
      'count': instance.count,
      'streaming': instance.streaming,
      'followable': instance.followable,
      'following': instance.following,
      'blocking': instance.blocking,
      'followsYou': instance.followsYou,
      'stream': instance.stream,
      'streamer': instance.streamer,
    };

const _$TitleEnumMap = {
  Title.gm: 'GM',
  Title.wgm: 'WGM',
  Title.im: 'IM',
  Title.wim: 'WIM',
  Title.fm: 'FM',
  Title.wfm: 'WFM',
  Title.nm: 'NM',
  Title.cm: 'CM',
  Title.wcm: 'WCM',
  Title.wnm: 'WNM',
  Title.lm: 'LM',
  Title.bot: 'BOT',
};

_$_LiveStream _$$_LiveStreamFromJson(Map<String, dynamic> json) =>
    _$_LiveStream(
      service: json['service'] as String?,
      status: json['status'] as String?,
      lang: json['lang'] as String?,
    );

Map<String, dynamic> _$$_LiveStreamToJson(_$_LiveStream instance) =>
    <String, dynamic>{
      'service': instance.service,
      'status': instance.status,
      'lang': instance.lang,
    };

_$_LiveStreamer _$$_LiveStreamerFromJson(Map<String, dynamic> json) =>
    _$_LiveStreamer(
      name: json['name'] as String?,
      headline: json['headline'] as String?,
      description: json['description'] as String?,
      twitch: json['twitch'] as String?,
      youTube: json['youTube'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$_LiveStreamerToJson(_$_LiveStreamer instance) =>
    <String, dynamic>{
      'name': instance.name,
      'headline': instance.headline,
      'description': instance.description,
      'twitch': instance.twitch,
      'youTube': instance.youTube,
      'image': instance.image,
    };

_$_RealTimeUserStatus _$$_RealTimeUserStatusFromJson(
        Map<String, dynamic> json) =>
    _$_RealTimeUserStatus(
      id: json['id'] as String?,
      name: json['name'] as String?,
      title: json['title'] as String?,
      online: json['online'] as bool? ?? false,
      playing: json['playing'] as bool? ?? false,
      streaming: json['streaming'] as bool? ?? false,
      patron: json['patron'] as bool?,
      playingId: json['playingId'] as String?,
    );

Map<String, dynamic> _$$_RealTimeUserStatusToJson(
        _$_RealTimeUserStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'online': instance.online,
      'playing': instance.playing,
      'streaming': instance.streaming,
      'patron': instance.patron,
      'playingId': instance.playingId,
    };

_$_Profile _$$_ProfileFromJson(Map<String, dynamic> json) => _$_Profile(
      country: json['country'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fideRating: json['fideRating'] as int?,
      uscfRating: json['uscfRating'] as int?,
      ecfRating: json['ecfRating'] as int?,
      links: json['links'] as String?,
    );

Map<String, dynamic> _$$_ProfileToJson(_$_Profile instance) =>
    <String, dynamic>{
      'country': instance.country,
      'location': instance.location,
      'bio': instance.bio,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fideRating': instance.fideRating,
      'uscfRating': instance.uscfRating,
      'ecfRating': instance.ecfRating,
      'links': instance.links,
    };

_$_UserPreferences _$$_UserPreferencesFromJson(Map<String, dynamic> json) =>
    _$_UserPreferences(
      dark: json['dark'] as bool?,
      transp: json['transp'] as bool?,
      bgImg: json['bgImg'] as String?,
      is3d: json['is3d'] as bool?,
      theme: $enumDecodeNullable(_$ThemeEnumMap, json['theme']),
      pieceSet: $enumDecodeNullable(_$PieceSetEnumMap, json['pieceSet']),
      theme3d: $enumDecodeNullable(_$Theme3dEnumMap, json['theme3d']),
      pieceSet3d: $enumDecodeNullable(_$PieceSet3dEnumMap, json['pieceSet3d']),
      soundSet: json['soundSet'] as String?,
      blindfold: json['blindfold'] as int?,
      autoQueen: json['autoQueen'] as int?,
      autoThreefold: json['autoThreefold'] as int?,
      takeback: json['takeback'] as int?,
      moretime: json['moretime'] as int?,
      clockTenths: json['clockTenths'] as int?,
      clockBar: json['clockBar'] as bool?,
      clockSound: json['clockSound'] as bool?,
      premove: json['premove'] as bool?,
      animation: json['animation'] as int?,
      captured: json['captured'] as bool?,
      follow: json['follow'] as bool?,
      highlight: json['highlight'] as bool?,
      destination: json['destination'] as bool?,
      coords: json['coords'] as int?,
      replay: json['replay'] as int?,
      challenge: json['challenge'] as int?,
      message: json['message'] as int?,
      coordColor: json['coordColor'] as int?,
      submitMove: json['submitMove'] as int?,
      confirmResign: json['confirmResign'] as int?,
      insightShare: json['insightShare'] as int?,
      keyboardMove: json['keyboardMove'] as int?,
      zen: json['zen'] as int?,
      moveEvent: json['moveEvent'] as int?,
      rookCastle: json['rookCastle'] as int?,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$$_UserPreferencesToJson(_$_UserPreferences instance) =>
    <String, dynamic>{
      'dark': instance.dark,
      'transp': instance.transp,
      'bgImg': instance.bgImg,
      'is3d': instance.is3d,
      'theme': _$ThemeEnumMap[instance.theme],
      'pieceSet': _$PieceSetEnumMap[instance.pieceSet],
      'theme3d': _$Theme3dEnumMap[instance.theme3d],
      'pieceSet3d': _$PieceSet3dEnumMap[instance.pieceSet3d],
      'soundSet': instance.soundSet,
      'blindfold': instance.blindfold,
      'autoQueen': instance.autoQueen,
      'autoThreefold': instance.autoThreefold,
      'takeback': instance.takeback,
      'moretime': instance.moretime,
      'clockTenths': instance.clockTenths,
      'clockBar': instance.clockBar,
      'clockSound': instance.clockSound,
      'premove': instance.premove,
      'animation': instance.animation,
      'captured': instance.captured,
      'follow': instance.follow,
      'highlight': instance.highlight,
      'destination': instance.destination,
      'coords': instance.coords,
      'replay': instance.replay,
      'challenge': instance.challenge,
      'message': instance.message,
      'coordColor': instance.coordColor,
      'submitMove': instance.submitMove,
      'confirmResign': instance.confirmResign,
      'insightShare': instance.insightShare,
      'keyboardMove': instance.keyboardMove,
      'zen': instance.zen,
      'moveEvent': instance.moveEvent,
      'rookCastle': instance.rookCastle,
      'language': instance.language,
    };

const _$ThemeEnumMap = {
  Theme.blue: 'blue',
  Theme.blue2: 'blue2',
  Theme.blue3: 'blue3',
  Theme.blueMarble: 'blue-marble',
  Theme.canvas: 'canvas',
  Theme.wood: 'wood',
  Theme.wood2: 'wood2',
  Theme.wood3: 'wood3',
  Theme.wood4: 'wood4',
  Theme.maple: 'maple',
  Theme.maple2: 'maple2',
  Theme.brown: 'brown',
  Theme.leather: 'leather',
  Theme.green: 'green',
  Theme.marble: 'marble',
  Theme.greenPlastic: 'green-plastic',
  Theme.grey: 'grey',
  Theme.metal: 'metal',
  Theme.olive: 'olive',
  Theme.newspaper: 'newspaper',
  Theme.purple: 'purple',
  Theme.purpleDiag: 'purple-diag',
  Theme.pink: 'pink',
  Theme.ic: 'ic',
};

const _$PieceSetEnumMap = {
  PieceSet.cburnett: 'cburnett',
  PieceSet.merida: 'merida',
  PieceSet.alpha: 'alpha',
  PieceSet.pirouetti: 'pirouetti',
  PieceSet.chessnut: 'chessnut',
  PieceSet.chess7: 'chess7',
  PieceSet.reillycraig: 'reillycraig',
  PieceSet.companion: 'companion',
  PieceSet.riohacha: 'riohacha',
  PieceSet.kosal: 'kosal',
  PieceSet.leipzig: 'leipzig',
  PieceSet.fantasy: 'fantasy',
  PieceSet.spatial: 'spatial',
  PieceSet.california: 'california',
  PieceSet.pixel: 'pixel',
  PieceSet.maestro: 'maestro',
  PieceSet.fresca: 'fresca',
  PieceSet.cardinal: 'cardinal',
  PieceSet.gioco: 'gioco',
  PieceSet.tatiana: 'tatiana',
  PieceSet.staunty: 'staunty',
  PieceSet.governor: 'governor',
  PieceSet.dubrovny: 'dubrovny',
  PieceSet.icpieces: 'icpieces',
  PieceSet.shapes: 'shapes',
  PieceSet.letter: 'letter',
};

const _$Theme3dEnumMap = {
  Theme3d.blackWhiteAluminium: 'Black-White-Aluminium',
  Theme3d.brushedAluminium: 'Brushed-Aluminium',
  Theme3d.chinaBlue: 'China-Blue',
  Theme3d.chinaGreen: 'China-Green',
  Theme3d.chinaGrey: 'China-Grey',
  Theme3d.chinaScarlet: 'China-Scarlet',
  Theme3d.classicBlue: 'Classic-Blue',
  Theme3d.goldSilver: 'Gold-Silver',
  Theme3d.lightWood: 'Light-Wood',
  Theme3d.powerCoated: 'Power-Coated',
  Theme3d.rosewood: 'Rosewood',
  Theme3d.marble: 'Marble',
  Theme3d.wax: 'Wax',
  Theme3d.jade: 'Jade',
  Theme3d.woodi: 'Woodi',
};

const _$PieceSet3dEnumMap = {
  PieceSet3d.basic: 'Basic',
  PieceSet3d.wood: 'Wood',
  PieceSet3d.metal: 'Metal',
  PieceSet3d.redVBlue: 'RedVBlue',
  PieceSet3d.modernJade: 'ModernJade',
  PieceSet3d.modernWood: 'ModernWood',
  PieceSet3d.glass: 'Glass',
  PieceSet3d.trimmed: 'Trimmed',
  PieceSet3d.experimental: 'Experimental',
  PieceSet3d.staunton: 'Staunton',
  PieceSet3d.cubesAndPi: 'CubesAndPi',
};

_$_Team _$$_TeamFromJson(Map<String, dynamic> json) => _$_Team(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      open: json['open'] as bool?,
      leader: json['leader'] == null
          ? null
          : User.fromJson(json['leader'] as Map<String, dynamic>),
      leaders: (json['leaders'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      nbMembers: json['nbMembers'] as int?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$_TeamToJson(_$_Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'open': instance.open,
      'leader': instance.leader,
      'leaders': instance.leaders,
      'nbMembers': instance.nbMembers,
      'location': instance.location,
    };

_$_PageOf<T> _$$_PageOfFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$_PageOf<T>(
      currentPage: json['currentPage'] as int?,
      maxPerPage: json['maxPerPage'] as int?,
      currentPageResults: (json['currentPageResults'] as List<dynamic>?)
          ?.map(fromJsonT)
          .toList(),
      nbResults: json['nbResults'] as int?,
      previousPage: json['previousPage'] as int?,
      nextPage: json['nextPage'] as int?,
      nbPages: json['nbPages'] as int?,
    );

Map<String, dynamic> _$$_PageOfToJson<T>(
  _$_PageOf<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'maxPerPage': instance.maxPerPage,
      'currentPageResults': instance.currentPageResults?.map(toJsonT).toList(),
      'nbResults': instance.nbResults,
      'previousPage': instance.previousPage,
      'nextPage': instance.nextPage,
      'nbPages': instance.nbPages,
    };

_$_JoinRequest _$$_JoinRequestFromJson(Map<String, dynamic> json) =>
    _$_JoinRequest(
      teamId: json['teamId'] as String?,
      userId: json['userId'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      date: json['date'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_JoinRequestToJson(_$_JoinRequest instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'userId': instance.userId,
      'user': instance.user,
      'date': instance.date,
      'message': instance.message,
    };
