import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSecret;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final GlobalKey<FormFieldState>? formFieldKey;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isSecret = false,
    this.inputFormatter,
    this.initialValue,
    this.readOnly = false,
    this.validator,
    this.onSaved,
    this.textEditingController,
    this.textInputType,
    this.formFieldKey,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        key: widget.formFieldKey,
        controller: widget.textEditingController,
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        obscureText: isObscure,
        keyboardType: widget.textInputType,
        obscuringCharacter: '*',
        inputFormatters: widget.inputFormatter,
        validator: widget.validator,
        onSaved: widget.onSaved,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          label: Text(widget.label),
        ),
      ),
    );
  }
}
