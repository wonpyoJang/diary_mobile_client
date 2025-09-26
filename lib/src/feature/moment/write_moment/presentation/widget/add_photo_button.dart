import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPhotoButton extends StatelessWidget {
  const AddPhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<WriteMomentBloc>().add(const AddMedias());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFF965C),
          borderRadius: BorderRadius.circular(22.0),
        ),
        child: const Center(child: Icon(Icons.camera_alt)),
      ),
    );
  }
}
