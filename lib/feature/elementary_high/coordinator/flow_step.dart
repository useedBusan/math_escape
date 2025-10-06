enum FlowStepType { intro, conversation, question }

class FlowStep {
  final FlowStepType type;
  final int stage; // 1-based

  FlowStep(this.type, this.stage);

  @override
  String toString() => 'FlowStep(${type.name}, stage: $stage)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowStep &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          stage == other.stage;

  @override
  int get hashCode => type.hashCode ^ stage.hashCode;
}

