enum VerificationStep {
  lookForward,
  blink,
  lookUp,
  lookDown,
  turnLeft,
  turnRight,
  smile,
  done,
}

extension VerificationStepExt on VerificationStep {
  String get imageAsset {
    switch (this) {
      case VerificationStep.lookForward:
        return "assets/icons/ic_face.png";
      case VerificationStep.blink:
        return "assets/icons/ic_eye.png";
      case VerificationStep.lookUp:
        return "assets/icons/ic_face_up.png";
      case VerificationStep.lookDown:
        return "assets/icons/ic_face_down.png";
      case VerificationStep.turnLeft:
        return "assets/icons/ic_face_left.png";
      case VerificationStep.turnRight:
        return "assets/icons/ic_face_right.png";
      case VerificationStep.smile:
        return "assets/icons/ic_smile.png";
      case VerificationStep.done:
        return "assets/icons/ic_verified.png";
    }
  }

  String get instruction {
    switch (this) {
      case VerificationStep.lookForward:
        return "Look straight";
      case VerificationStep.blink:
        return "Blink";
      case VerificationStep.lookUp:
        return "Look Up";
      case VerificationStep.lookDown:
        return "Look Down";
      case VerificationStep.turnLeft:
        return "Turn Left";
      case VerificationStep.turnRight:
        return "Turn Right";
      case VerificationStep.smile:
        return "Smile";
      case VerificationStep.done:
        return "Verified";
    }
  }
}
