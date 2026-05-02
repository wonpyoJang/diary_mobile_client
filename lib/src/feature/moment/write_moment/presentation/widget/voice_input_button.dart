import 'package:diary_mobile_client/l10n/app_localizations.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInputButton extends StatefulWidget {
  final TextEditingController controller;
  const VoiceInputButton({super.key, required this.controller});

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _baseText = '';

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  String _resolveLocaleId(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final country = locale.countryCode;
    if (country != null && country.isNotEmpty) {
      return '${locale.languageCode}_$country';
    }
    switch (locale.languageCode) {
      case 'ko':
        return 'ko_KR';
      case 'ja':
        return 'ja_JP';
      case 'zh':
        return 'zh_CN';
      default:
        return 'en_US';
    }
  }

  Future<void> _toggle(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final bloc = context.read<WriteMomentBloc>();
    final localeId = _resolveLocaleId(context);

    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _isListening = false);
        messenger.showSnackBar(SnackBar(content: Text(l10n.voiceInputError)));
      },
    );

    if (!available) {
      if (!mounted) return;
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.voiceInputUnavailable)));
      return;
    }

    _baseText = widget.controller.text;
    if (mounted) setState(() => _isListening = true);

    final needsSeparator = _baseText.isNotEmpty &&
        !_baseText.endsWith(' ') &&
        !_baseText.endsWith('\n');
    final separator = needsSeparator ? ' ' : '';

    await _speech.listen(
      localeId: localeId,
      onResult: (result) {
        if (!mounted) return;
        final newText = _baseText + separator + result.recognizedWords;
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
        bloc.add(TextChangedEvent(newText));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color =
        _isListening ? const Color(0xFFE53935) : const Color(0xFFFF965C);
    return Tooltip(
      message: l10n.voiceInput,
      child: InkWell(
        onTap: () => _toggle(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: Center(
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
