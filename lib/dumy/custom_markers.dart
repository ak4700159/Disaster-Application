// custom_markers.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

// 대피소 정보를 모아둔 더미
class CustomMarkerInfo {
  final String markerId;
  final LatLng position;
  final String title;
  final String info;

  CustomMarkerInfo({
    required this.markerId,
    required this.position,
    required this.title,
    required this.info,
  });
}

List<CustomMarkerInfo> customMarkers = [
  /*//계대역
  CustomMarkerInfo(
    markerId: "custom_marker_1",
    position: LatLng(35.8632694, 128.490464),
    title: "한화꿈에그린아파트(지하1층 주차장) 대피소",
    info: "커스텀 마커 설명 1",
  ),
  */

  CustomMarkerInfo(
    markerId: "custom_marker_2",
    position: LatLng(35.8632694, 128.490464),
    title: "한화꿈에그린아파트(지하1층 주차장) 대피소",
    info: "수용인원 4,800명",
  ),
  CustomMarkerInfo(
    markerId: "custom_marker_3",
    position: LatLng(35.8530918, 128.478341),
    title: "강창역(지하2층 역사) 대피소",
    info: "수용인원 2,339명",
  ),
  CustomMarkerInfo(
    markerId: "custom_marker_4",
    position: LatLng(35.8537495, 128.474689),
    title: "우방유쉘(지하1층 주차장) 대피소",
    info: "수용인원 8,203명",
  ),
  CustomMarkerInfo(
    markerId:"custom_marker_5",
    position: LatLng(35.8588913, 128.504817),
    title: "서한2차아파트 대피소",
    info: "수용인원 2,772명",
  ),
  CustomMarkerInfo(
    markerId: "custom_marker_6",
    position: LatLng(35.8576148, 128.503841),
    title: "동서서한아파트 대피소",
    info: "수용인원 3,200명",
  ),
  CustomMarkerInfo(
    markerId: "custom_marker_7",
    position: LatLng(35.8556738, 128.504125),
    title: "보성화성아파트 대피소",
    info: "수용인원 4,105명",
  ),
  CustomMarkerInfo(
    markerId:"custom_marker_8",
    position: LatLng(35.8540803, 128.500398),
    title: "청남타운 대피소",
    info: "수용인원 3,989명",
  ),
  CustomMarkerInfo(
    markerId: "custom_marker_9",
    position: LatLng(35.8524038, 128.500422),
    title: "대백창신한라아파트 대피소",
    info: "수용인원 892명",
  ),
];
