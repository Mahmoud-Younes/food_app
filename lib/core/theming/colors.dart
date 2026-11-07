import 'package:flutter/material.dart';

/// The spice-stall palette (بساط التوابل) — the approved visual world,
/// recorded in .impeccable/direction.md and .impeccable/decision-payload.json
/// (option `model-pick`).
class ColorsManager {
  ColorsManager._();

  // ── World tokens ─────────────────────────────────────────────────────

  /// Warm bone — the light-mode ground; wipes out clinical white.
  static const Color bone = Color(0xFFF3E6D2);

  /// Roasted umber — the ink for primary text on bone surfaces.
  static const Color umber = Color(0xFF2A1F18);

  /// Red pepper — the commitment color: AppBar, selected category pile,
  /// primary actions.
  static const Color pepper = Color(0xFFB33A25);

  /// Turmeric gold — secondary touches and quiet highlights.
  static const Color turmeric = Color(0xFFE0A526);

  /// Cumin brown — tags, borders and secondary text on bone.
  static const Color cumin = Color(0xFF8A5A2B);

  /// Night-market ground — warm dark brown (never grey) for dark mode.
  static const Color darkGround = Color(0xFF1C1410);

  /// Slightly raised warm surface above the dark ground (bars, fields).
  static const Color darkGroundRaised = Color(0xFF261B13);

  /// Muted bone for hints and secondary text on the dark ground.
  static const Color darkGroundMuted = Color(0xFFC9AE8B);

  // ── Brightness-resolved inks & surfaces ──────────────────────────────
  // Screens read these through Theme.brightness so every surface stays
  // valid in both modes without raw color literals at call sites.

  /// Primary ink for body text: umber on bone (light), bone on the
  /// night-market ground (dark).
  static Color ink(Brightness brightness) =>
      brightness == Brightness.dark ? bone : umber;

  /// Secondary ink: cumin on bone (light), muted bone on the dark ground.
  static Color mutedInk(Brightness brightness) =>
      brightness == Brightness.dark ? darkGroundMuted : cumin;

  /// Raised surface above the ground (cards, chips, rows, fields).
  static Color raisedSurface(Brightness brightness) =>
      brightness == Brightness.dark ? darkGroundRaised : white;

  // ── Established names (every existing call site stays valid) ─────────
  // Values re-pigmented to the spice-stall world; names unchanged.
  static const Color primary = pepper;
  static const Color primaryLight = Color(0xFFF4E3BE);
  static const Color darkText = umber;
  static const Color greyText = cumin;
  static const Color lightGrey = Color(0xFFEADCC0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFE04B3A);
  static const Color yellow = turmeric;
}
