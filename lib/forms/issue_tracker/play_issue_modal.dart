import 'dart:convert';

List<PlayIssue?>? playIssueFromJson(String str) =>
    str.isEmpty ? [] : List<PlayIssue?>.from(json.decode(str).map((x) => PlayIssue.fromJson(x)));
String playIssueToJson(List<PlayIssue?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class PlayIssue {
  PlayIssue({
    this.id,
    this.playIssue,
    this.playIssueValue,
    this.playDesc,
    this.uniqueId,
    this.playIssueImg,
    this.reportedOn,
    this.reportedBy,
    this.issueStatus,
    this.resolvedOn,
    this.resolvedBy,
  });

  int? id;
  String? playIssue;
  String? playIssueValue;
  String? playDesc;
  String? uniqueId;
  String? playIssueImg;
  String? reportedOn;
  String? reportedBy;
  String? issueStatus;
  String? resolvedOn;
  String? resolvedBy;

  factory PlayIssue.fromJson(Map<String, dynamic> json) => PlayIssue(
    id: json["id"],
    playIssue: json["play_issue"],
    playIssueValue: json["play_issue_value"],
    playDesc: json["play_desc"],
    uniqueId: json["unique_id"],
    playIssueImg: json["play_issue_img"],
    reportedOn: json["reported_on"],
    reportedBy: json["reported_by"],
    issueStatus: json["issue_status"],
    resolvedOn: json["resolved_on"],
    resolvedBy: json["resolved_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "play_issue": playIssue,
    "play_issue_value": playIssueValue,
    "play_desc": playDesc,
    "unique_id": uniqueId,
    "play_issue_img": playIssueImg,
    "reported_on": reportedOn,
    "reported_by": reportedBy,
    "issue_status": issueStatus,
    "resolved_on": resolvedOn,
    "resolved_by": resolvedBy,
  };
}
