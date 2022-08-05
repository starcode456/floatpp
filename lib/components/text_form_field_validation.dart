import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum CurrencyNumberFormat { number, currency }
enum WhitelistingTextInput { positive, positiveNegative }

typedef Null ValueChangeCallback(String value);
typedef Null OnSavedChangeCallback(String value);

class TextFormFieldValidation extends StatefulWidget {
  final ValueChangeCallback onValueChanged;
  final String hint;
  final TextEditingController controller;
  final Function validator;
  final Color containerColor;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChangeCallback onSaved;
  final bool isEnabled;
  final String initialValue;
  final bool obscureText;
  final int maxLines;
  final int maxLength;
  final bool isNumberCurrencyInput;
  final CurrencyNumberFormat currencyNumberFormatType;
  final WhitelistingTextInput whitelistingTextType;

  TextFormFieldValidation({
    Key key,
    @required this.hint,
    this.controller,
    this.onValueChanged,
    this.isEnabled = true,
    this.onSaved,
    this.keyboardType,
    this.textCapitalization,
    this.validator,
    this.containerColor,
    this.initialValue,
    this.obscureText,
    this.maxLength,
    this.maxLines,
    this.isNumberCurrencyInput = false,
    this.currencyNumberFormatType = CurrencyNumberFormat.number,
    this.whitelistingTextType = WhitelistingTextInput.positiveNegative,
  }) : super(key: key);

  @override
  _TextFormFieldValidationState createState() =>
      _TextFormFieldValidationState();
}

class _TextFormFieldValidationState extends State<TextFormFieldValidation> {
  TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    valueController = widget.controller ??
        TextEditingController.fromValue(
            TextEditingValue(text: widget.initialValue ?? ""));
    valueController.addListener(() {
      if (widget.onValueChanged != null) {
        widget.onValueChanged(valueController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextFormField(
        inputFormatters: widget.isNumberCurrencyInput
            ? [
                if (widget.whitelistingTextType ==
                    WhitelistingTextInput.positive)
                  FilteringTextInputFormatter(RegExp("[0-9]"), allow: null),
                if (widget.whitelistingTextType ==
                    WhitelistingTextInput.positiveNegative)
                  FilteringTextInputFormatter(RegExp("[0-9-]"), allow: null),
                if (widget.currencyNumberFormatType ==
                    CurrencyNumberFormat.number)
                  NumberInputFormatter(),
                if (widget.currencyNumberFormatType ==
                    CurrencyNumberFormat.currency)
                  CurrencyInputFormatter()
              ]
            : null,
        maxLength: widget.maxLength ?? null,
        maxLines: widget.maxLines ?? 1,
        enabled: widget.isEnabled ?? true,
        onSaved: (String value) {
          if (widget.isNumberCurrencyInput) {
            value = value.replaceAll('\$', '');
            value = value.replaceAll(',', '');
          }
          widget.onSaved(value);
        },
        keyboardType: widget.keyboardType ?? TextInputType.text,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        obscureText: widget.obscureText ?? false,
        controller: valueController,
        validator: widget.validator ??
            (String value) {
              if (value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
        decoration: InputDecoration(
          prefix:
              widget.currencyNumberFormatType == CurrencyNumberFormat.currency
                  ? Text('\$')
                  : null,
          filled: widget.isEnabled ? true : false,
          fillColor: Theme.of(context).backgroundColor,
          labelText: widget.hint,
          labelStyle:
              Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).accentColor.withOpacity(.1)),
              borderRadius: BorderRadius.circular(20)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).focusColor),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).accentColor.withOpacity(.1)),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains('-')) {
      String textValue = newValue.text;
      if (textValue.endsWith('-') && textValue.startsWith('-')) {
        textValue = textValue.replaceAll('-', '');
        newValue = newValue.copyWith(text: textValue);
      } else {
        textValue = textValue.replaceAll('-', '');
        textValue = '-' + textValue;
        newValue = newValue.copyWith(text: textValue);
      }
    }

    double value = double.parse(newValue.text);

    final formatter = new NumberFormat("#,##0.00", "en_US");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class NumberInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains('-')) {
      String textValue = newValue.text;
      if (textValue.endsWith('-') && textValue.startsWith('-')) {
        textValue = textValue.replaceAll('-', '');
        newValue = newValue.copyWith(text: textValue);
      } else {
        textValue = textValue.replaceAll('-', '');
        textValue = '-' + textValue;
        newValue = newValue.copyWith(text: textValue);
      }
    }

    print(newValue.text);

    double value = double.tryParse(newValue.text) ?? 0.0;

    final formatter = new NumberFormat("#,##0");

    String newText = formatter.format(value);
    if (newText == '0') {
      newText = '';
    }

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
