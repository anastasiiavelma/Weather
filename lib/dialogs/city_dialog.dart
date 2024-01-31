import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:list_app/utils/constants.dart';

class CityDialog extends StatefulWidget {
  final Function(String) onAction;
  final String? initialCityName;
  final bool isEditing;

  const CityDialog({
    Key? key,
    required this.onAction,
    this.initialCityName,
    this.isEditing = false,
  }) : super(key: key);

  @override
  CityDialogState createState() => CityDialogState();
}

class CityDialogState extends State<CityDialog> {
  late TextEditingController cityController;
  String? errorText;

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController(text: widget.initialCityName);
  }

  void validateCity(String cityName) {
    setState(() {
      errorText =
          cityName.isEmpty ? AppLocalizations.of(context)!.error1 : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kPrimaryColor,
      title: Center(
        child: Text(
          widget.isEditing
              ? AppLocalizations.of(context)!.editing
              : AppLocalizations.of(context)!.adding,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              widget.isEditing
                  ? AppLocalizations.of(context)!.pleaseEditCity
                  : AppLocalizations.of(context)!.pleaseAddCity,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              hintStyle: Theme.of(context).textTheme.bodySmall,
              hintText: AppLocalizations.of(context)!.enterCityName,
              errorText: errorText,
            ),
            onChanged: validateCity,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        TextButton(
          onPressed: () {
            String cityName = cityController.text;
            if (cityName.isNotEmpty) {
              widget.onAction(cityName);
              Navigator.of(context).pop();
            }
          },
          child: Text(
            widget.isEditing
                ? AppLocalizations.of(context)!.save
                : AppLocalizations.of(context)!.add,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}
