import '../../../recitation/domain/entities/recitation_session_entity.dart';
import 'smart_recitation_excerpt_entity.dart';

/// جلسة سبر ذكي + أسئلتها المجمّدة معاً - نفس الشكل سواء كانت جلسة
/// جديدة (POST .../sessions) أو جلسة مستأنفة (GET .../upcoming).
class SmartRecitationSessionBundle {
  const SmartRecitationSessionBundle({required this.session, required this.excerpts});

  factory SmartRecitationSessionBundle.fromJson(Map<String, dynamic> json) {
    final excerptsJson = (json['excerpts'] as List<dynamic>?) ?? const [];
    return SmartRecitationSessionBundle(
      session: RecitationSessionEntity.fromJson(json['session'] as Map<String, dynamic>),
      excerpts: excerptsJson
          .map((e) => SmartRecitationExcerptEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final RecitationSessionEntity session;
  final List<SmartRecitationExcerptEntity> excerpts;
}
