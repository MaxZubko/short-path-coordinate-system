import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_path_coordinate_system/constants/constants.dart';
import 'package:short_path_coordinate_system/cubit/coordinates_cubit/coordinates_cubit.dart';
import 'package:short_path_coordinate_system/cubit/coordinates_cubit/coordinates_state.dart';
import 'package:short_path_coordinate_system/features/process_screen/process_screen.dart';
import 'package:short_path_coordinate_system/services/database/shared_preferences_methods.dart';
import 'package:short_path_coordinate_system/widgets/default_button.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _initializeTextController();
  }

  Future<void> _initializeTextController() async {
    String url = await getUrl();
    _controller.text = url;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoordinatesCubit, CoordinatesState>(
      builder: (context, state) {
        final CoordinatesCubit cubit =
            BlocProvider.of<CoordinatesCubit>(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              if (state is ErrorCoordinates) ...[
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.error,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(
                    Icons.published_with_changes_rounded,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: DefaultButton(
                  title: 'Start counting process',
                  onPressed: () async {
                    final enteredUrl = _controller.text;
                    if (enteredUrl.isNotEmpty &&
                        cubit.checkEnteredUrl(url: enteredUrl)) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProcessScreen(),
                        ),
                      );

                      await saveUrl(enteredUrl);
                      cubit.getCoordinates(url: enteredUrl);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> getUrl() async {
    final SharedPreferencesMethods db = SharedPreferencesMethods();
    final String? url = await db.getUrl(sharedPrefUrlKey);

    return url ?? '';
  }

  Future<bool> saveUrl(String url) async {
    final SharedPreferencesMethods db = SharedPreferencesMethods();
    final bool isSaved = await db.setUrl(sharedPrefUrlKey, url);

    return isSaved;
  }
}
